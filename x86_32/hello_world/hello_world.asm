section .data
	msg 	db 'hello world!', 0
	len 	equ $-msg

section .text
	global _start
_start:
	mov 	eax, 4    ; print("hello world!");
	mov 	ebx, 1
	mov 	ecx, msg
	mov 	edx, len
	int 	0x80

	mov 	eax, 0    ; return 0;
	mov 	ebx, 0
	int 	0x80
