%include 	'../functions.asm'

section 	.data
	msg1 	db 'please enter your string: ', 0
	msg2 	db 'your string has ', 0
	msg3 	db ' characters', 0

section 	.bss
	string: 	resb 256

section 	.text
	global _start

_start:
	push 	msg1 			;print(msg1)
	call 	print
	add 	esp, 4

	mov 	eax, string 	;scan(string)
	mov 	ebx, 256
	call 	take_input
	
	push 	msg2 			;print(msg2)
	call 	print
	add 	esp, 4

	mov 	eax, string 	;eax = strlen(eax)
	call 	slen

	call 	print_eax 		; print(eax)
	
	push 	msg3 			;print(msg3)
	call 	print
	add 	esp, 4

	call 	finish 			; return 0;
