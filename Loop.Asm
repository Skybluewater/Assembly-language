.386
.model flat, stdcall
option casemap:none

includelib msvcrt.lib
printf proto c :dword, :vararg
scanf proto c: dword,:vararg

.data
a	dd	?
b	dd	?
d	dd	?
temp 	dd	0
msOut	byte	'The number is %d....',0ah,0
tips 	byte	'Please input three numbers: ',0ah,0
input	byte	'%d %d %d',0
res	byte	'您输入了负数，不符合条件',0ah,0

.code
start:

	invoke printf,offset tips
	invoke scanf ,offset input,offset a,offset b,offset d

	cmp a,0		;判断a,b,c是否为负数，是就输出错误信息
	js f
	cmp b,0
	js f
	cmp d,0
	js f
	
	mov eax,0	;1.因为先自增了，而且判断小于等于，所以把初值设置为0	
i:
	mov ebx,0	;2.同1
	inc eax
	cmp eax,a
	jna j		;3.jna 小于等于
	jmp final

j:
	mov edx,1
	inc ebx
	cmp ebx,b
	jna k
	jmp i

k:			;4.最内层循环
	inc edx
	inc temp	;5.数据测量
	;invoke	printf, offset msOut, temp
	cmp edx,d
	jna k
	jmp j
	

final:
	invoke	printf, offset msOut, temp
	jmp ff
f:
	invoke printf,offset res

ff:	
	ret;return

end start
