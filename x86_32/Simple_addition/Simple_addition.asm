%include 	'../functions.asm'

section 	.data
	msg1 	db 'enter first number:  ', 0
	msg2 	db 'enter second number: ', 0
	msg3 	db 'sum of two number:   ', 0

section 	.bss
	num1: 	resb 10 	; number has 9 digits is safe for 32-bit register
	num2: 	resb 10

section 	.text
	global _start

_start:

	push 	msg1  		; print(msg1)
	call 	print
	add 	esp, 4

	mov 	eax, num1 	; scan(num1)
	mov 	ebx, 10
	call 	take_input
	
	push 	msg2 		; print(msg2)
	call 	print
	add 	esp, 4
	
	mov 	eax, num2 	; scan(num2)
	mov 	ebx, 10
	call 	take_input
	
	push 	num1 		; num1 = int(num1)
	call 	atoi

	mov 	ebx, eax 	; reserve num1
	
	push 	num2 		; num2 = int(num2)
	call 	atoi

	add 	eax, ebx 	; eax = num1 + num2

	push 	msg3	
	call 	print
	add 	esp, 4

	call 	print_eax 	; print(eax)

	call 	finish
