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
szTemplate          db  "(%d ~ %d)随机数：", 13, 10, 13, 10,"         %d", 13, 10, 13, 10, 13, 10, 0
N1	            dd  0
N2            	    dd  0

.code

Rand   proc uses ecx edx first:DWORD, second:DWORD
   invoke GetTickCount ; 取得随机数种子,指从操作系统启动所经过（elapsed）的毫秒数，返回值是DWORD
   mov ecx, 23         
   mul ecx            
   add eax, 7          
   mov ecx, second     ;second是上限，first是下限
   sub ecx, first      ; ecx = 上限 - 下限
   inc ecx             ; 得到了范围
   xor edx, edx        
   div ecx            
   add edx, first      ; 修正产生的随机数的范围
   mov eax, edx        ; eax即随机数
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
               ;获得上限：
               invoke GetDlgItemInt, hWnd, EDIT_N1, NULL, TRUE
               mov N1, eax
               ;获得下限：
               invoke GetDlgItemInt, hWnd, EDIT_N2, NULL, TRUE
               mov N2, eax
               ;产生随机数：
               invoke Rand, N1, N2
               ;输出：
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



