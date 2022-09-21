%include 	'../functions.asm'

section .bss
	s: 		resb 256

section .text
	global _start

_start:

	mov 	eax, s
	mov 	ebx, 256
	call 	take_input

	push 	s
	call 	print
	add 	esp, 4

	call 	finish
