.386
.model flat,stdcall    					;stdcall调用方式
option casemap:none    

include  windows.inc
include  shell32.inc
include  user32.inc
include  comctl32.inc
include  masm32.inc
include  kernel32.inc

includelib  user32.lib
includelib  comctl32.lib
includelib  masm32.lib
includelib  kernel32.lib
includelib  shell32.lib
includelib  msvcrt.lib

atoi proto c:dword
_itoa proto c:dword,:dword,:dword

.data
MenuName db "FirstMenu",0 ; The name of our menu in the resource file.
About_string db '作者： 陶国梁', 0ah,0dh,0ah,0dh,'本计算器仅为陶国梁服务',0ah,0dh,0ah,0dh,'时间：2016-12-9', 0

Goodbye_string db "仅会员可以设置此权限，您当前还不是会员！",0

 .data?
hInstance dd  ?
hWinMain dd  ?
numstr1	db	400 dup(0)
numstr2	db	400 dup(0)
restr	db	400 dup(0)
num1	dd	?
num2	dd	?
num3	dq	0.0
num4	dq	0
	
len1	dword	0
len2	dword	0
len	dword	0
num	db	0					;用来规定此时是在输入哪个数
opera	db	?					;用来说明是什么运算

.const
IDM_TEST equ 4001 ; Menu IDs
IDM_Clear equ 4002
IDM_GOODBYE equ 4003
IDM_EXIT equ 4004

szClassName db 'MyClass',0
szCaptionMain db '计算器1.1',0
szText    db '0',0
szCaption db 'A MessageBox ! ',0
text1	 db	'static',0				;static是文本框的一种类型 还有edit类型
textcont1 db	'0',0
text2	db	'static',0
textcont2 db	'0',0
text3	db	'static',0
textcont3 db	'0',0
flag	db	'static',0
EQUAL	db	'static',0
							;定义按钮
szButton1 db 'button',0
szButton2 db 'button',0
szButton3 db 'button',0
szButton4 db 'button',0
szButton5 db 'button',0
szButton6 db 'button',0
szButton7 db 'button',0
szButton8 db 'button',0
szButton9 db 'button',0
szButton0 db 'button',0
szButton_add db 'button',0
szButton_sub db 'button',0
szButton_mul db 'button',0
szButton_div db 'button',0
szButton_ac db 'button',0
szButton_equ db 'button',0

szButtonText0 db '0',0
szButtonText1 db '1',0
szButtonText2 db '2',0
szButtonText3 db '3',0
szButtonText4 db '4',0
szButtonText5 db '5',0
szButtonText6 db '6',0
szButtonText7 db '7',0
szButtonText8 db '8',0
szButtonText9 db '9',0
szButtonText_add db '+',0
szButtonText_sub db '-',0
szButtonText_mul db '*',0
szButtonText_div db '/',0
szButtonText_equ db '=',0
szButtonText_ac db 'AC',0

.code

AC proc	hWnd
	push	ecx
		mov	num,0
		
		.if	len1 > 0
		mov	ecx,len1
	q0:	mov	numstr1[ecx],0
		dec	ecx
		cmp	ecx,0
		ja	q0
		.endif
		
		.if	len2 > 0
		mov	ecx,len2
	q1:	mov	numstr2[ecx],0
		dec	ecx
		cmp	ecx,0
		ja	q1	
		.endif
		
		.if	len > 0
		mov	ecx,len
	q2:	mov	restr[ecx],0
		dec	ecx
		cmp	ecx,0
		ja	q2	
		.endif
		mov	len1,0
		mov	len2,0
		mov	len,0
		pop	ecx
		invoke	SetDlgItemText,hWnd,298,NULL
		invoke	SetDlgItemText,hWnd,299,NULL
		invoke	SetDlgItemText,hWnd,300,addr szText
		invoke	SetDlgItemText,hWnd,301,addr szText
		invoke	SetDlgItemText,hWnd,302,addr szText
		;.endif 
	ret
AC	endp
	
_ProcWinMain proc uses ebx edi esi hWnd,uMsg,wParam,lParam
  	local @stPs:PAINTSTRUCT
  	local @stRect:RECT
  	local @hDc
  	mov eax,uMsg
	
  	.if uMsg == WM_CHAR     ;热键操作
  		mov eax,wParam         		
         	add eax,100
         	sub eax,'0'       
   		.if (eax==119 || eax==151)  	 ; c 清零
         	invoke	AC,hWnd
         	.elseif(eax==117 || eax==149) 
         	invoke MessageBox,NULL,ADDR About_string,OFFSET szCaptionMain,MB_OK
         	.elseif (eax==121 || eax==153) 		 ; e 退出
         	invoke DestroyWindow,hWinMain
   		invoke PostQuitMessage,NULL
   		
   		.endif
   	.elseif eax == WM_CREATE				;生成Button按钮的语句,1,2,3,4.......数值就是button的ID
	invoke CreateWindowEx,NULL,offset szButton1,offset szButtonText1,WS_CHILD or WS_VISIBLE,0,150,60,60,hWnd,1,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton2,offset szButtonText2,WS_CHILD or WS_VISIBLE,60,150,60,60,hWnd,2,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton3,offset szButtonText3,WS_CHILD or WS_VISIBLE,120,150,60,60,hWnd,3,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton_add,offset szButtonText_add,WS_CHILD or WS_VISIBLE,180,150,60,60,hWnd,10,hInstance,NULL
	
	invoke CreateWindowEx,NULL,offset szButton4,offset szButtonText4,WS_CHILD or WS_VISIBLE,0,210,60,60,hWnd,4,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton5,offset szButtonText5,WS_CHILD or WS_VISIBLE,60,210,60,60,hWnd,5,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton6,offset szButtonText6,WS_CHILD or WS_VISIBLE,120,210,60,60,hWnd,6,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton_sub,offset szButtonText_sub,WS_CHILD or WS_VISIBLE,180,210,60,60,hWnd,11,hInstance,NULL
	
	invoke CreateWindowEx,NULL,offset szButton7,offset szButtonText7,WS_CHILD or WS_VISIBLE,0,270,60,60,hWnd,7,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton8,offset szButtonText8,WS_CHILD or WS_VISIBLE,60,270,60,60,hWnd,8,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton9,offset szButtonText9,WS_CHILD or WS_VISIBLE,120,270,60,60,hWnd,9,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton_mul,offset szButtonText_mul,WS_CHILD or WS_VISIBLE,180,270,60,60,hWnd,12,hInstance,NULL

	invoke CreateWindowEx,NULL,offset szButton0,offset szButtonText0,WS_CHILD or WS_VISIBLE,60,330,60,60,hWnd,0,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton_div,offset szButtonText_div,WS_CHILD or WS_VISIBLE,180,330,60,60,hWnd,13,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton_equ,offset szButtonText_equ,WS_CHILD or WS_VISIBLE,120,330,60,60,hWnd,14,hInstance,NULL
	invoke CreateWindowEx,NULL,offset szButton_ac,offset szButtonText_ac,WS_CHILD or WS_VISIBLE,0,330,60,60,hWnd,15,hInstance,NULL

	invoke CreateWindowEx,NULL,offset flag,NULL,WS_CHILD or WS_VISIBLE or ES_RIGHT,215,40,20,20,hWnd,298,hInstance,NULL
	invoke CreateWindowEx,NULL,offset EQUAL,NULL,WS_CHILD or WS_VISIBLE or ES_RIGHT,215,100,20,20,hWnd,299,hInstance,NULL	
	invoke CreateWindowEx,NULL,offset text1,offset textcont1,WS_CHILD or WS_VISIBLE or ES_RIGHT,0,10,235,20,hWnd,300,hInstance,NULL
	invoke CreateWindowEx,NULL,offset text2,offset textcont2,WS_CHILD or WS_VISIBLE or ES_RIGHT,0,70,235,20,hWnd,301,hInstance,NULL
	invoke CreateWindowEx,NULL,offset text3,offset textcont3,WS_CHILD or WS_VISIBLE or ES_RIGHT,0,130,235,20,hWnd,302,hInstance,NULL	
	;invoke CreateWindowEx,NULL,offset text1,offset textcont1, WS_CHILD or WS_VISIBLE or ES_RIGHT,0,10,235,20,hWnd,300, hInstance,NULL	
                
        .elseif eax == WM_COMMAND						;点击按钮发生的事件
		mov eax,wParam  
		
		.IF ax==IDM_TEST
		invoke MessageBox,NULL,ADDR About_string,OFFSET szCaptionMain,MB_OK
		.ELSEIF ax==IDM_Clear
		invoke	AC,hWnd
		.ELSEIF ax==IDM_GOODBYE
		invoke MessageBox,NULL,ADDR Goodbye_string, OFFSET szCaptionMain, MB_OK
		.elseif	ax==IDM_EXIT
		invoke ExitProcess,NULL
		.elseif ax >= 0 && ax <= 9
			add	ax,30h
			.if num == 0						;当前输入第一个数
			mov	ecx,len1
			inc	len1
			mov	numstr1[ecx][1],al
			invoke	SetDlgItemText,hWnd,300,addr numstr1+1
			.else					;当前输入第二个数
			mov	ecx,len2
			inc	len2
			mov	numstr2[ecx][1],al
			invoke	SetDlgItemText,hWnd,301,addr numstr2+1
			.endif
		
		.elseif ax == 10					;加
		mov	num,2
		mov	opera,10
		invoke	SetDlgItemText,hWnd,298,addr szButtonText_add
		
		.elseif ax == 11					;减
		mov	num,2
		mov	opera,11						
		invoke	SetDlgItemText,hWnd,298,addr szButtonText_sub
		
		.elseif ax == 12					;乘
		mov	num,2
		mov	opera,12
		invoke	SetDlgItemText,hWnd,298,addr szButtonText_mul
		
		.elseif ax == 13					;除
		mov	num,2
		mov	opera,13
		invoke	SetDlgItemText,hWnd,298,addr szButtonText_div
		
		.elseif ax == 14					;等于
		invoke	SetDlgItemText,hWnd,299,addr szButtonText_equ
		
		;******************此处是计算器的功能部分*************
	
		
		;**************上面代码实现了字符到数字的转化********
		;**************此处用来计算**************************
			xor	eax,eax
			xor	ebx,ebx
			xor	ecx,ecx
			xor	edx,edx
			.if opera == 10
			
			mov	ecx,len1
			xor	edx,edx
		L1:
			sub	numstr1[edx][1],30h
			inc	edx
			cmp	ecx,edx
			ja	L1	
		
			mov	ecx,len2
			xor	edx,edx
		L2:
			sub	numstr2[edx][1],30h
			inc	edx
			cmp	ecx,edx
			ja	L2	
		
			mov	ecx,len1
			mov	edx,len2
				.if	ecx >= edx
				mov	len,ecx
			L3:	mov	bl,numstr2[edx]	
				add	numstr1[ecx],bl
				movzx	ax,numstr1[ecx]
				mov	bl,10
				div	bl
				mov	numstr1[ecx],ah
				add	numstr1[ecx-1],al
				add	numstr1[ecx],30h
				dec	ecx
				dec	edx
					cmp	edx,0
					jg	LL
					mov	edx,0
				LL:	
					.if	ecx > 0
						jmp	L3
					.endif
					xor	ebx,ebx
					.while	numstr1[ebx] == 30h || numstr1[ebx] == 0
						inc	ebx
						.if	ebx == len
							.break
						.endif
					.endw	
				invoke	SetDlgItemText,hWnd,302,addr numstr1[ebx]
				
				.else
				mov	len,edx	
			L4:
				
				mov	bl,numstr1[ecx]	
				add	numstr2[edx],bl
				xor	ax,ax
				movzx	ax,numstr2[edx]
				mov	bl,10
				div	bl
				
				mov	numstr2[edx],ah
				add	numstr2[edx],30h
				add	numstr2[edx-1],al				
				dec	ecx
				dec	edx				
					cmp	ecx,0
					jg	L			;此处有个BUG卡了我一晚上，.if不能判断负数<0
					mov	ecx,0		
				L:	
					
					.if	edx > 0
						jmp	L4
					.endif
					xor	ebx,ebx
					.while	numstr2[ebx] == 30h || numstr2[ebx] == 0
						inc	ebx
						.if	ebx == len
							.break
						.endif
					.endw	
					
				invoke	SetDlgItemText,hWnd,302,addr numstr2[ebx]
		
				.endif
			
			
			;接着完成减法,乘除法........
			
			.elseif opera == 11			;减法
				invoke 	atoi, addr numstr1[1]
				mov	num1,eax
				xor	eax,eax
				invoke  atoi, addr numstr2[1]
				sub	num1,eax
				invoke _itoa, num1, offset restr, 10 
				invoke	SetDlgItemText,hWnd,302,offset restr
				
			.elseif	opera == 12			;乘法
;				invoke 	atoi, addr numstr1[1]
;				mov	num1,eax
;				xor	eax,eax
;				invoke  atoi, addr numstr2[1]
;				xor	edx,edx			;32*32
;				mov	ebx,num1
;				mul	ebx
;				
;				.if	edx == 0
;					invoke _itoa, eax, offset restr, 10 
;				.else
;					
;					;invoke _itoa, edx, offset restr, 10 ;待实现更高位的乘法，现在乘积必须小于2~32-1
;					invoke _itoa, eax,offset restr, 10 
;				.endif
;				invoke	SetDlgItemText,hWnd,302,offset restr

				invoke 	atoi, addr numstr1[1]
				mov	num1,eax
				fild	num1			;浮点数运算指令，整数入栈
				xor	eax,eax
				invoke  atoi, addr numstr2[1]
				mov	num2,eax
				fimul	num2			;浮点数乘法，两个整数相乘
				fstp	num4			;浮点数出栈
				invoke	FloatToStr , num4,addr restr
				invoke	SetDlgItemText,hWnd,302,offset restr	
				
			.elseif	opera == 13			;除法
				invoke 	atoi, addr numstr1[1]
				mov	num1,eax
				fld	num1			;浮点数运算指令，入栈
				xor	eax,eax
				invoke  atoi, addr numstr2[1]
				mov	num2,eax
				.if	num2 == 0
					mov restr,'e'
					inc	eax
					mov restr[eax],"r"
					inc	eax
					mov restr[eax],"r"
					inc	eax
					mov restr[eax],"o"
					inc	eax
					mov restr[eax],"r"
					mov restr[eax][1],0
					jmp	z
				.endif	
				fdiv	num2			;浮点数除法
				fstp	num3			;浮点数出栈
				invoke	FloatToStr , num3,addr restr
			z:	invoke	SetDlgItemText,hWnd,302,offset restr	
			.endif
			
		.elseif ax == 15					;清零
		invoke	AC,hWnd
		.endif	
		
	
  	.elseif eax == WM_CLOSE 				;窗口关闭事件
   	invoke DestroyWindow,hWinMain
   	invoke PostQuitMessage,NULL

  	.else
   	invoke DefWindowProc,hWnd,uMsg,wParam,lParam
   	ret
								;消息的默认处理
  	.endif
  	xor eax,eax
 	ret
_ProcWinMain endp

_WinMain proc
  	local @stWndClass:WNDCLASSEX
  	local @stMsg:MSG
  	invoke GetModuleHandle,NULL
  	mov hInstance,eax
									;使用参数NULL调用GetModuleHandle得到调用者本模块的句柄
  	invoke  RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
									;用RtlZeroMemory将WNDCLASSEX结构的变量@stWndClass填为全零。

									; 注册窗口类

  	invoke LoadCursor,0,IDC_ARROW
  	mov 	@stWndClass.hCursor,eax 				;用LoadCursor为光标句柄赋值
  	push 	hInstance
 	pop 	@stWndClass.hInstance  					;指定要注册的窗口类属于哪个模块
  	mov	@stWndClass.cbSize,sizeof WNDCLASSEX 			;指定结构的长度
  	mov 	@stWndClass.style,CS_HREDRAW or CS_VREDRAW 		;窗口风格
									;建议使用”or”不使用”+”，因为1or1=1，而1+1=2了。
  	mov @stWndClass.lpfnWndProc,offset _ProcWinMain 		;窗口过程地址
  	mov @stWndClass.hbrBackground,COLOR_WINDOW + 1 			;客户区背景色
  	mov @stWndClass.lpszMenuName,OFFSET MenuName 				; Put our menu name here,定义菜单
  	mov @stWndClass.lpszClassName,offset szClassName 		;为此类命名
  	invoke RegisterClassEx,addr @stWndClass
									;hIcon------图标句柄，指定显示在窗口标题栏左上角的图标。
									;cbclsextra和cbwndextra------预留的空间，用来存放自定义数据，不使用就是0。
									;lpszmenuname------窗口菜单
									;hiconsm------小图标
									; 建立并显示窗口

  	invoke CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,offset szCaptionMain,WS_OVERLAPPEDWINDOW and WS_SYSMENU or WS_MINIMIZEBOX,100,100,260,455,\
   			NULL,NULL,hInstance,NULL
   			
  	mov hWinMain,eax  						;窗口句柄
  	invoke ShowWindow,hWinMain,SW_SHOWNORMAL
 	invoke UpdateWindow,hWinMain
									; UpdateWindow实际上就是向窗口发送一条WM_PAINT消息。
									; 消息循环
  	.while TRUE 							;WM_QUIT时eax=0
   	invoke GetMessage,addr @stMsg,NULL,0,0
   	.break .if eax == 0
   	invoke TranslateMessage ,addr @stMsg
   	invoke DispatchMessage,addr @stMsg
  	.endw
  	ret
_WinMain endp

start:
  	call _WinMain
  	invoke ExitProcess,NULL

  end start