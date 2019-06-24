.586 
.mmx 
.model flat,stdcall
option casemap:none

includelib	msvcrt.lib
printf	proto c:dword,:vararg
scanf	proto c:dword,:vararg

.data
tip1	byte	"Please Input:",0ah,0
szF1	byte	"%s",0
szF2	byte	"The copyone is %s.",0ah,0
szF4	byte	"The Length is %d.",0ah,0
str1	byte	100 DUP(0)
str2	byte	100 DUP(?)
time	DD	?

.code
start:
	invoke	printf,offset tip1
	invoke	scanf,addr szF1,addr str1
	
	xor	ecx,ecx
    L1:
	mov	al,str1[ecx]
	mov	str2[ecx],al
	inc	ecx
	cmp	str1[ecx],0
	jnz	L1
	
	invoke	printf,offset szF4,ecx
	invoke	printf,addr szF2,addr str2
	
	ret
end start
