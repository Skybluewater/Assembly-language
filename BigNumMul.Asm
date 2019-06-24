.386
.model flat, stdcall
option casemap:none

includelib msvcrt.lib
scanf proto c:dword,:vararg
printf proto c:dword,:vararg
strlen proto c:dword,:vararg

.data

	num1	byte	100 dup(?)
	num2	byte	100 dup(?)
	mid	byte	20000 dup(0)
	res	byte	200 dup(?)
	len1	dword	?
	len2	dword	?
	len	dword	?
	temp 	dd	0
	
	tip1	byte	'请输入第一个数',0ah,0
	tip2	byte	'请输入第二个数',0ah,0
      	input  	byte '%s',0
      	output 	byte '恭喜你，结果是: %s',0ah,0
      	;oo	byte '%d',0ah,0		;用来调试的

.code

start:
	invoke 	printf, offset tip1
    	invoke  scanf,addr input,addr num1
    	invoke 	printf, offset tip2
    	invoke  scanf,addr input,addr num2
    	
    	
    	
	invoke 	strlen,addr num1
	mov 	len1,eax	
	mov	len,eax			;求num1与num2两个数组的长度
	xor	eax,eax
	invoke 	strlen,addr num2
	mov 	len2,eax
	add	len,eax
	
;Part1 	
	mov	eax,-1	
convert1:
	inc 	eax
	cmp	eax,len1			;把两个字符串数组的字符转化为数字 -‘0’30h是其ASCII值
	je	a	
	sub	num1[eax],30h			
	jmp	convert1

a:	
	mov 	eax,-1
convert2:	
	inc 	eax
	cmp	eax,len2	
	je	b
	sub	num2[eax],30h	
	jmp	convert2
	
b:



;Part2	
	mov 	ecx,-1
L1:	
	inc 	ecx
	cmp 	ecx,len2
	jz  	break
	mov 	edi,-1			 ;对edi进行初始化,ecx表示i,edi表示j
		
L2:
	inc 	edi
	cmp	edi,len1
	jz	L1
	mov 	esi,edi
	add	esi,ecx
	xor	eax,eax
	mov 	al,num1[edi]
	mul 	num2[ecx]
	push	ecx
	push	eax
	mov	ax,cx
	mov	ebx,100			;此处的100与第117行的100可以变大，结果可以增大精度，但是数组要相应的变大
	mul	bx
	mov	cx,dx
	shl	ecx,16
	mov	cx,ax			;此段代码为了让数组不会被重叠
	pop	eax
	mov 	mid[ecx][esi],al
	pop	ecx
	jmp 	L2
	
break:
	
;part3
	xor 	edx,edx			;ecx是s,edx是h
	xor	ecx,ecx
	mov 	esi,len			;esi是j,ebx是i	
	sub	esi,1
L3:
	dec	esi	
	cmp	esi,0
	jl	L6	
	mov	ecx,edx
	mov	ebx,len2		;对i进行初始化
	
L4:
	dec	ebx
	cmp	ebx,0
	jl	L5
	push	ebx
	mov	ax,bx
	mov	ebx,100
	mul	bx
	mov	bx,dx
	shl	ebx,16
	mov	bx,ax
			
	mov	al,mid[ebx][esi]
	movzx	ebx,al
	add	ecx,ebx
	pop	ebx
	jmp	L4	
			
L5:
	mov	ax,cx
	shr	ecx,16			;将ecx高16位放入dx
	mov	dx,cx
	;invoke	printf,offset o,temp
	mov	bx,10			;除法运算,此处可扩展为更高位数的除法
	div	bx
	add	dx,30h	
	mov	res[esi][1],dl	
	mov	dx,ax
	jmp	L3
	
L6:
	add	dl,30h
	mov	res[0],dl
	cmp	dl,0
	jz	L7
	jmp	result
L7:
	mov	res,30h

result:	
	xor	ebx,ebx
	dec	len
	.while	res[ebx] == 30h
		inc	ebx		
		.if	ebx == len
			.break
		.endif
		
	.endw	
	
	invoke 	printf,addr output,addr res[ebx]

ret


end start