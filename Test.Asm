.586 
.mmx 
.model flat,stdcall
option casemap:none

include  masm32.inc
includelib  masm32.lib

includelib  msvcrt.lib
printf	proto c:dword,:vararg
fopen	proto c:dword,:dword
fgets	proto c:dword,:dword,:dword
fputs	proto c:dword,:dword
fclose  proto c:dword

.data
tip1	byte	"Please Input:",0ah,0
szF1	byte	"%s",0
szF3	byte	"The time is %lf ms.",0ah,0
szF4	byte	"The time is %lf s.",0ah,0

modestr2	byte	"wb",0
modestr3	byte	"rb",0

file1	byte	"11.txt",0
file2	byte	"12.txt",0
fp1	dd	?
fp2	dd	?
str1	byte	256 DUP(0)
str2	byte	256 DUP(0)

timeb	dd	?
timea	dd	?
timeres	dq	?

base	dq	4294967296
hz2	dd	2400000000
sz	dd	1000
stdio	dd	1

.code
start:
	
	invoke	fopen,offset file1,offset modestr3
	mov	fp1,eax
	invoke	fopen,offset file2,offset modestr2
	mov	fp2,eax
	
	RDTSC
	mov	timeb,edx
	fild	timeb
	fild	base
	fmul
	mov	timeb,eax
	fiadd	timeb
		
    L1:	
	invoke  fgets,addr str2,256,fp1
	test	eax,eax
	je	L2
	invoke  fputs,addr str2,fp2
	jmp	L1
    L2:	
    	invoke fclose,fp1
	invoke fclose,fp2
	RDTSC
	
	mov	timea,edx
	fild	timea
	fild	base
	fmul	
	mov	timea,eax
	fiadd	timea
	
	fsub	
	fidiv	hz2
	
	ficom	stdio
	jc	L3
		fimul	sz
		fst	timeres
		invoke	printf ,addr szF3,timeres
		jmp	L4
	L3:
		fst	timeres
		invoke	printf ,addr szF4,timeres
	L4:
	
	ret
end start
