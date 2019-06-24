.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib

fopen	proto c:dword,:dword
fgets	proto c:dword,:dword,:dword
fclose  proto c:dword
strcmp	proto c:dword,:dword
strlen	proto c:dword
scanf	proto c szformat:dword,:vararg
printf	proto c:dword,:vararg

.data
fp1	dword	?
buf1	byte	1024 dup(0)		;读入到缓冲区
bytes1	dword	?			;读入的项数	
pos1	dword	0			;读写指针的位置
file1	byte	"11.txt",0

fp2	dword	?
buf2	byte	1024 dup(0)		;读入到缓冲区
bytes2	dword	?			;读入的项数
pos2	dword	0			;读写指针的位置
file2	byte	"12.txt",0

no	dword	0			;显示行号
flag	dword	0			;用来标记文件是否有不相同的
mode	byte	"rb",0			;必须定义成字节型的
res	byte	'No.%d is different.',0ah,0
sz	byte	"The two files are the same.",0ah,0

.code
start:
	
	invoke	fopen,offset file1,offset mode		;返回*fp给 函数返回值在eax
	mov	fp1,eax
	invoke	fopen,offset file2,offset mode
	mov	fp2,eax

L1:
	xor	eax,eax
	mov	buf1,al
	mov	buf2,al
	invoke	fgets,offset buf1,1024,fp1
	push	eax
	invoke	fgets,offset buf2,1024,fp2
	push	eax
	inc	no					;让行号+1，区别于flag，flag只在59行+1
	
	;**********此处用来处理回车可能引起的错误，忽略回车换行引起的差异*******
	;fgets读文本文件的机制是读到文件的“回车”与“换行”字符时将两个字符转化为换行，即0dh，再在字符串末尾加上0字符
	;strlen会把0字符也算作串长的一位，因此要-2那一位是换行字符的所在位置
	
	invoke strlen,offset buf1
	sub eax,2					
	.if buf1[eax]  == 0dh
		xor ebx,ebx
		mov buf1[eax],bl
	.endif
	invoke strlen,offset buf2
	sub eax,2
	.if buf2[eax]  == 0dh
		xor ebx,ebx
		mov buf2[eax],bl
	.endif
	
	;********比较读入的两个字符串有无差异************
	invoke	strcmp,offset buf1,offset buf2
	cmp	eax,0
	jnz	L2
L3:	pop	eax
	pop	ebx					;此处需比较两个文件是否均读到了头，因为两个文件行数可以不同
	cmp	eax,ebx
	jz	L4
	jmp	L1	
L2:
	inc flag
	invoke	printf,offset res,no	
	jmp	L3
	
L4:	
	mov	eax,flag
	cmp 	eax,0
	jnz	L5
	invoke	printf,offset sz
L5:
	invoke	 fclose,fp1
	invoke	 fclose,fp2
	ret
	
end start