%include 	'../functions.asm'

section .data
	msg1 	db "your selection (1 is Upper and 0 is Lower): ", 0
	msg2 	db "please enter your input:    ", 0
	msg3 	db "your output            :    ", 0

section .bss
	sel: 			resb 2
	string: 		resb 256

section .text
	global _start

_start:
	push 	msg1 		; print(msg1)
	call 	print
	add 	esp, 4

	mov 	eax, sel 	; scan(sel)
	mov 	ebx, 2
	call 	take_input

	push 	msg2 		; print(msg2)
	call 	print
	add 	esp, 4

	mov 	eax, string 	; scan(string)
	mov 	ebx, 256
	call 	take_input

	push 	msg3
	call 	print
	add 	esp, 4

	push 	string

	cmp 	BYTE [sel], '1'
	jz 		.Upper

	call 	Lowercase
	jmp .finish

	.Upper:
	call Uppercase

	.finish:
	
	call 	print	
	call 	finish
