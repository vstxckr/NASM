;---------------------------------------------------------------------- 
; void take_input(eax: pointer, ebx: size)
take_input:    			
	push 	ebp 
	mov 	ebp, esp
	
	push 	eax 		; reserve registers
	push 	ebx	
	push 	ecx
	push 	edx

	mov 	ecx, eax 	; same as scanf("%s", eax);
	mov 	edx, ebx
	mov 	eax, 3
	mov 	ebx, 0
	int 	0x80

	pop 	edx 		; return reservation values
	pop 	ecx
	pop 	ebx
	pop 	eax

	pop 	ebp 
	ret

;---------------------------------------------------------------------- 
; int slen(eax: pointer) -> eax
slen:
	push 	ebp
	mov 	ebp, esp

	push 	ecx 						; reserve ecx
	mov 	ecx, 0 						; ecx = 0;

	.head_loop: 						;
		cmp 	BYTE [eax], 0 			; while (*eax != '\0' || *eax != ''\n')
		jz 		.end_loop 				; 
		cmp 	BYTE [eax], 0xa 		; 		ecx++;
		jz 		.end_loop 				; 		eax++;
		inc 	ecx 					;
		inc 	eax 					;
		jmp 	.head_loop 				;
	.end_loop:	 						;
	mov 	eax, ecx 					; eax = ecx;  // ecx is considered a counter 

	pop 	ecx

	pop 	ebp
	ret

;---------------------------------------------------------------------- 
; void print(ebp+8: pointer)
;---------------------------------------------------------------------- 
;		 .......
;		 +-----+
;		 | EBP |
;		 +-----+ 
;		 | RET |
;		 +-----+
;		 | arg | 
;		 +-----+
;		 .......
print: 					
	push 	ebp
	mov 	ebp, esp

	push 	eax 				; reserve registers
	push 	ebx	
	push 	ecx
	push 	edx

	mov 	eax, [ebp+0x8] 		; calculate the length of string
	call 	slen 				;

	mov 	edx, eax 			; same as printf("%s", eax); // eax is pointer to char*
	mov 	eax, 4 				;
	mov 	ebx, 1 				;
	mov 	ecx, [ebp+0x8] 		;
	int 	0x80 				;

	pop 	edx
	pop 	ecx
	pop 	ebx
	pop 	eax

	pop 	ebp
	ret

;---------------------------------------------------------------------- 
; void Uppercase(ebp+8: pointer)
Uppercase:  			
	push 	ebp
	mov 	ebp, esp
	
	push 	eax
	mov 	eax, [ebp+0x8]

	.head_loop: 							; 
	 										;
		cmp 	BYTE [eax], 0 				; while (*eax == 0)
		jz 		.end_loop 					; 
											;
		.stage_1: 							;
		cmp 	BYTE [eax], 97 				;	  if (*eax >= 97 && *eax <= 122)
		jge 	.stage_2 					;	   
		inc 	eax 						;			*eax -= 32;
		jmp 		.head_loop 					;	  else 
											;	  
		.stage_2: 							;			eax++
		cmp 	BYTE [eax], 122  			;
		jle 	.impl 						;
		inc 	eax 						;
		jmp 	.head_loop	 				;
											;
		.impl: 								;
		sub 	BYTE [eax], 32 				;
		inc  	eax 						;
		jmp 	.head_loop 					;

	.end_loop:

	pop 	eax

	pop 	ebp
	ret

;---------------------------------------------------------------------- 
; void Lowercase(ebp+8: pointer)
Lowercase:
	push 	ebp
	mov 	ebp, esp
	
	push 	eax
	mov 	eax, [ebp+0x8]

	.head_loop: 					; while (*eax != 0)
 									; 
		cmp 	BYTE [eax], 0 		;
		jz 		.end_loop 			;
 									;
		.stage_1: 					; 		if (*eax >= 65 && *eax <= 90) 
		cmp 	BYTE [eax], 65 		;
		jge 	.stage_2 			; 				*eax += 32
		inc 	eax 				; 
		jmp 		.head_loop 			; 		else
 									;
		.stage_2: 					; 				eax++;
		cmp 	BYTE [eax], 90  	;
		jle 	.impl 				;
		inc 	eax 				;
		jmp 	.head_loop	 		;
 									;
		.impl: 						;
		add 	BYTE [eax], 32 		;
		inc  	eax 				;
		jmp 	.head_loop 			;
									;
	.end_loop: 						;

	pop 	eax

	pop 	ebp
	ret


;---------------------------------------------------------------------- 
; void print_eax(eax: int) 		// but it's acctually itoa()
print_eax: 
	push 	ebp
	mov 	ebp, esp
	
	push 	ebx
	push 	ecx
	push 	edx
	push 	0x0

	mov 	ebx, 0xa
	mov 	ecx, [ebp+0x8]

	.push_loop:
		mov 	edx, 0x0 		;while (eax !=0)
		cmp 	eax, 0x0 		;
		jz 		.print_loop 	; 	edx = 0, eax /=10; // the remainder after division will be hold in edx
		div 	ebx  			; 	push 	 edx+48
		add 	edx, 48  		;
		push 	edx 			
		jmp 	.push_loop

	.print_loop:
		cmp 	DWORD [esp], 0x0 	;while (*esp != 0)
		jz 		.finish
		mov 	ecx, esp 			; 	print(edx)
		mov 	eax, 4
		mov 	ebx, 1
		mov 	edx, 1
		int 	0x80
		pop 	ecx
		jmp 	.print_loop

	.finish:
	add 	esp, 4

	pop 	edx
	pop 	ecx
	pop 	ebx

	pop 	ebp
	ret

;---------------------------------------------------------------------- 
; int atoi(ebp+8: pointer) -> eax
atoi:
	push 	ebp
	mov 	ebp, esp

	push 	ebx 					; reserve registers
	push 	ecx
	push 	edx

	mov 	ecx, [ebp+8] 			; ecx = ebp+8; // (char*)
	mov 	ebx, 0 					; ebx = 0;
	mov 	eax, 0 					; eax = 0;

	.head_loop: 					; while (*ecx != '\n')
		mov 	edx, 10 			; 
		cmp 	BYTE [ecx], 0xa 	; 		ebx = *ecx - 48;
		jz 		.end_loop 			; 		eax = eax*10 + ebx;
		mov 	bl, BYTE [ecx] 		; 		ecx++;
		sub 	ebx, '0' 			;
 									;
		mul 	edx 				;
		add 	eax, ebx 			;
		inc 	ecx 				;
		jmp 	.head_loop 			;
	.end_loop: 						;

	pop 	edx
	pop 	ecx
	pop 	ebx

	pop 	ebp
	ret


finish:
	mov 	eax, 1 		; syscall exit
	mov 	ebx, 0
	int 	0x80
