.386
.model flat, stdcall
option casemap:none

include windows.inc
include kernel32.inc
include user32.inc
includelib kernel32.lib
includelib user32.lib

.const
BUTTON	equ 3000
EDIT_N1 equ 3001
EDIT_N2	equ 3002

.data
szDlgName           db  "Dialog", 0
szDlgName1           db  "Dialog1", 0
szCaption           db  "Rand Number by TGL", 0
szText              db  255 dup(0)
szTemplate          db  "(%d ~ %d)�������", 13, 10, 13, 10,"         %d", 13, 10, 13, 10, 13, 10, 0
N1	            dd  0
N2            	    dd  0

.code

Rand   proc uses ecx edx first:DWORD, second:DWORD
   invoke GetTickCount ; ȡ�����������,ָ�Ӳ���ϵͳ������������elapsed���ĺ�����������ֵ��DWORD
   mov ecx, 23         
   mul ecx            
   add eax, 7          
   mov ecx, second     ;second�����ޣ�first������
   sub ecx, first      ; ecx = ���� - ����
   inc ecx             ; �õ��˷�Χ
   xor edx, edx        
   div ecx            
   add edx, first      ; ����������������ķ�Χ
   mov eax, edx        ; eax�������
   ret
Rand   endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
   LOCAL hEdit: HWND

   .if uMsg == WM_CLOSE
       invoke EndDialog, hWnd, 0
       
   .elseif uMsg == WM_COMMAND
       mov eax, wParam
       mov edx, eax
       shr edx, 16
       movzx eax, ax
       .if edx == BN_CLICKED
           .if eax == IDCANCEL
               invoke EndDialog, hWnd, NULL
           .elseif eax == BUTTON || eax == IDOK
               ;������ޣ�
               invoke GetDlgItemInt, hWnd, EDIT_N1, NULL, TRUE
               mov N1, eax
               ;������ޣ�
               invoke GetDlgItemInt, hWnd, EDIT_N2, NULL, TRUE
               mov N2, eax
               ;�����������
               invoke Rand, N1, N2
               ;�����
               ;invoke GetModuleHandle, NULL
   	       ;invoke DialogBoxParam, eax, offset szDlgName1, 0, WndProc, 0
               invoke wsprintf, addr szText, addr szTemplate, N1, N2, eax
               invoke MessageBox, hWnd, addr szText, addr szCaption, MB_OK
           .endif
       .endif
   .else
       mov eax, FALSE
       ret
   .endif
   mov eax, TRUE
   ret
WndProc endp

main:
   invoke GetModuleHandle, NULL
   invoke DialogBoxParam, eax, offset szDlgName, 0, WndProc, 0
   invoke ExitProcess, eax

end main


