%include "Often_use_macro.2048"

global num_in_string
global trans_matrix
global copy_matrix
global write_matrix
global move_right
global move_down
global move_left
global move_up
global random
global reverce_string
global ReadX
global x

section .data

a		equ 33
c 		equ 13
ReadX		db 0,0,0

section .bss

x		resd 1
ForWrite	resb 20

section .text

;This procedure trans the matrix 4x4.
;1 parameter: pointer on matrix.
;All elements of matrix push in stack in a special sequence:
;Every fourth element push - every column. And then they pop.
;Break Nothing.

trans_matrix:	push ebp
		mov ebp,esp
		push esi
		push ecx
		push eax
		push ebx
		push edi
		push edx
		mov esi,[ebp+8]
		mov edx,esi
		mov edi,4
.new_string_push:
		mov ebx,4
.again_push:	mov eax,[esi]
		push eax
		add esi,16
		dec ebx
		cmp ebx,0
		jne .again_push
		mov esi,edx
		add esi,4
		mov edx,esi
		dec edi
		cmp edi,0
		jne .new_string_push
		mov esi,[ebp+8]
		add esi,60
		mov ebx,16
.again_pop:	pop eax
		mov [esi],eax
		sub esi,4
		dec ebx
		cmp ebx,0
		jne .again_pop
		pop edx
		pop edi
		pop ebx
		pop eax
		pop ecx
		pop esi
		mov esp,ebp
		pop ebp
		ret

;Copy one matrix from other matrix.Size of matrix 4x4.
;2 parameters: pointer on first matrix and pointer
;on second matrix. Copy second matrix in first matrix.
;Break nothing.

copy_matrix:	push ebp
		mov ebp,esp
		push esi
		push edi
		push ecx
		push eax
		xor eax,eax
		mov esi,[ebp+8]
		mov edi,[ebp+12]
		push esi
		call trans_matrix
		add esp,4
		mov ecx,16
.copy:		mov eax,[esi]
		mov [edi],eax
		xor eax,eax
		add edi,4
		add esi,4
		loop .copy
		mov esi,[ebp+8]
		push esi
		call trans_matrix
		add esp,4
		pop eax
		pop ecx
		pop edi
		pop esi
		mov esp,ebp
		pop ebp
		ret

;Write matrix in beatiful view.
;1 parameter: pointer on matrix.
;Break nothing.

write_matrix:	push ebp
		mov ebp,esp
		sub esp,4
		push esi
		push eax
		push ecx
		push ebx
		push edi
		push edx
		mov dword [ebp-4],10
		GOTOXY [ebp-4],25
		add dword [ebp-4],1
		mov esi,[ebp+8]
		mov edi,4
.Matrix:	cmp edi,0
		je .exit
		dec edi
		mov ebx,4
.repeat:	cmp ebx,0
		je .end_of_str
		dec ebx
		mov eax,[esi]
		push ForWrite
		call num_in_string
		add esp,4
		cmp ecx,1
		jne .next1
		push ecx
		SPACE
		SPACE
		SPACE
		pop ecx
		push ecx
		cmp byte [ForWrite],"0"
		jne .notzer
		mov byte [ForWrite],"."
.notzer:	KERNEL 4,1,ForWrite,ecx
		SPACE
		SPACE
		pop ecx
		add esi,4
		jmp .repeat
.next1:		cmp ecx,2
		jne .next2
		push ecx
		SPACE
		SPACE
		pop ecx
		push ecx
		KERNEL 4,1,ForWrite,ecx
		SPACE
		SPACE
		pop ecx
		add esi,4
		jmp .repeat
.next2:		cmp ecx,3
		jne .next3
		push ecx
		SPACE
		SPACE
		pop ecx
		push ecx
		KERNEL 4,1,ForWrite,ecx
		SPACE
		pop ecx
		add esi,4
		jmp .repeat
.next3:		push ecx
		SPACE
		pop ecx
		push ecx
		KERNEL 4,1,ForWrite,ecx
		SPACE
		pop ecx
		add esi,4
		jmp .repeat
.end_of_str:	push ecx
		GOTOXY [ebp-4],25
		add dword [ebp-4],1
		pop ecx
                mov ebx,2
.again2:        mov ecx,24
.space2:        push ecx
		SPACE
		pop ecx
                dec ecx
                cmp ecx,0
                jne .space2
		push ecx
		GOTOXY [ebp-4],25
		add dword [ebp-4],1
		pop ecx
                dec ebx
                cmp ebx,0
                jne .again2
		jmp .Matrix
.exit:		pop edx
		pop edi
		pop ebx
		pop ecx
		pop eax
		pop esi
		mov esp,ebp
		pop ebp
		ret

;Reverce of string.
;1 parameter: pointer on string.
;Parameters will get from stack.
;At first procedure push all elements of string and then pop them.
;Break nothing.

reverce_string: push ebp
                mov ebp,esp
                push esi
                push eax
                mov esi,[ebp+8]
.again_push:    cmp byte [esi],0
                je .next
                xor eax,eax
                mov al,[esi]
                push eax
                inc esi
                jmp .again_push
.next:          mov esi,[ebp+8]
.again_pop:     cmp byte [esi],0
                jz .exit
                xor eax,eax
                pop eax
                mov [esi],al
                inc esi
                jmp .again_pop
.exit:          pop eax
                pop esi
                mov esp,ebp
                pop ebp
                ret

;Transform number from eax in string and return length of string in ecx.
;2 parameters: number in eax and pointer on string.
;Number will get from eax, pointer on string will get from stack.
;At first this procedure write number in string in reverce order and then
;procedure reverce string.

num_in_string:  push ebp
                mov ebp,esp
                push esi
                mov esi,[ebp+8]
		mov ecx,10
.zero:		mov byte [esi],0
		inc esi
		loop .zero
		mov esi,[ebp+8]
                push ebx
                push edx
		xor ecx,ecx
                mov ebx,10
.again_div:     mov edx,0
                cmp eax,0
                je .exit
                div ebx
		inc ecx
                add edx,"0"
                mov [esi],dl
                inc esi
                jmp .again_div
.exit:         	cmp ecx,0
		jne .next
		mov byte [esi],"0"
		inc esi
		inc ecx
.next:		mov byte [esi],0
                pop edx
                pop ebx
                mov esi,[ebp+8]
                push esi
                call reverce_string
                add esp,4
                pop esi
                mov esp,ebp
                pop ebp
                ret

;This procedure move right all elements from matrix and counting score.
;In edi this procedure return 1 or 0. 1 - all is good, 0 - you lose.
;Current score will get from ebx. ebx=score. And return score after counting
;in ebx. Procedure check elements after one element and after
;add their if they equal or if next element equl 0.
;At first it checks 0-elements, and after that compare for equal elements.
;2 parameter: pointer on matrix and score in ebx.

move_right:	push ebp
		mov ebp,esp
		sub esp,8
		mov dword [ebp-4],0	;create two local var for count moves
		mov dword [ebp-8],ebx	;ebx=count
		push esi
		push edx
		push eax
		push ecx
		mov ecx,4
		mov esi,[ebp+8]
.repeat:	mov edx,3
.first_check:	cmp dword [esi+12],0
		jne .next_check1
		cmp dword [esi+8],0	;if in matrix two 0 then no add new elem
		je .lp1
		mov dword [ebp-4],1	;check move
.lp1:		mov eax,[esi+8]
		mov [esi+12],eax
		mov dword [esi+8],0
.next_check1:	cmp dword [esi+8],0
		jne .next_check2
		cmp dword [esi+4],0
		je .lp2
		mov dword [ebp-4],1
.lp2:		mov eax,[esi+4]
		mov [esi+8],eax
		mov dword [esi+4],0
.next_check2:	cmp dword [esi+4],0
		jne .next_check3
		cmp dword [esi],0
		je .lp3
		mov dword [ebp-4],1
.lp3:		mov eax,[esi]
		mov [esi+4],eax
		mov dword [esi],0
.next_check3:	dec edx
		cmp edx,0
		jne .first_check
		mov eax,[esi+12]
		mov ebx,[esi+8]
		cmp eax,ebx
		jne .next1
		cmp eax,0
		je .jump1
		mov dword [ebp-4],1
.jump1:		add eax,ebx
		add [ebp-8],eax
		mov [esi+12],eax
		mov eax,[esi+4]
		mov [esi+8],eax
		mov eax,[esi]
		mov [esi+4],eax
		mov dword [esi],0
.next1:		mov eax,[esi+8]
		mov ebx,[esi+4]
		cmp eax,ebx
		jne .next2
		cmp eax,0
		je .jump2
		mov dword [ebp-4],1
.jump2:		add eax,ebx
		add [ebp-8],eax
		mov [esi+8],eax
		mov eax,[esi]
		mov [esi+4],eax
		mov dword [esi],0
.next2:		mov eax,[esi+4]
		mov ebx,[esi]
		cmp eax,ebx
		jne .next3
		cmp eax,0
		je .jump3
		mov dword [ebp-4],1
.jump3:		add eax,ebx
		add [ebp-8],eax
		mov [esi+4],eax
		mov dword [esi],0
.next3:		add esi,16
		dec ecx
		cmp ecx,0
		jne .repeat
		mov edi,1
		cmp dword [ebp-4],0
		je .exit
.random:	call random
		mov esi,[ebp+8]
		cmp dword [esi+4*eax],0
		jne .random
		mov dword [esi+4*eax],2
.exit:		mov ebx,[ebp-8]
		mov esi,[ebp+8]
		push esi
		call check_end
		add esp,4
		mov edi,eax
		pop ecx
		pop eax
		pop edx
		pop esi
		mov esp,ebp
		pop ebp
		ret

;This prodeure reverce all strings in matrix.
;1 parameter: pointer on matrix.
;Break nothing.

reverce_strings_in_matrix:
		push ebp
		mov ebp,esp
		push esi
		push eax
		push ebx
		mov esi,[ebp+8]
		mov eax,4
.again:		mov ebx,[esi]
		push ebx
		mov ebx,[esi+4]
		push ebx
		mov ebx,[esi+8]
		push ebx
		mov ebx,[esi+12]
		mov [esi],ebx
		pop ebx
		mov [esi+4],ebx
		pop ebx
		mov [esi+8],ebx
		pop ebx
		mov [esi+12],ebx
		add esi,16
		dec eax
		cmp eax,0
		jne .again
		pop ebx
		pop eax
		pop esi
		mov esp,ebp
		pop ebp
		ret

;This procedure move left all elements in matrix.
;1 parameter: pointer on matrix.
;Use move right after reverce strings in matrix.
;Break nothing.

move_left:	push ebp
		mov ebp,esp
		push esi
		mov esi,[ebp+8]
		push esi
		call reverce_strings_in_matrix
		add esp,4
		push esi
		call move_right
		add esp,4
		push esi
		call reverce_strings_in_matrix
		add esp,4
		pop esi
		mov esp,ebp
		pop ebp
		ret

;This procedure move down all elements in matrix.
;Use trans_matrix and then move right.
;1 parameter: pointer on matrix.
;Break nothing.

move_down:	push ebp
		mov ebp,esp
		push esi
		mov esi,[ebp+8]
		push esi
		call trans_matrix
		add esp,4
		push esi
		call move_right
		add esp,4
		push esi
		call trans_matrix
		add esp,4
		pop esi
		mov esp,ebp
		pop ebp
		ret

;This procedure move up all elements in matrix.
;Use trans_matrix and then move left.
;1 parameter: pointer on matrix.
;Break nothing.

move_up:	push ebp
		mov ebp,esp
		push esi
		mov esi,[ebp+8]
		push esi
		call trans_matrix
		add esp,4
		push esi
		call move_left
		add esp,4
		push esi
		call trans_matrix
		add esp,4
		pop esi
		mov esp,ebp
		pop ebp
		ret

;This procedure give you a random number from 0 to 15 in eax.
;No parameters.

random:		push ebp
		mov ebp,esp
		push ebx
		push edx
		xor eax,eax
		xor edx,edx
		mov eax,[x]
		mov ebx,a
		mul ebx
		mov ebx,c
		add eax,ebx
		and eax,0000000Fh
		mov [x],eax
		pop edx
		pop ebx
		mov esp,ebp
		pop ebp
		ret

;This procedure check matrix for lose the game.
;If you lose it return 0 in eax, else return 1 in eax.
;1 parameter: pointer on matrix.
;Eax = result.

check_end:	push ebp
		mov ebp,esp
		push esi
		push ecx
		push ebx
		push edx
		mov esi,[ebp+8]
		mov ecx,16
		mov eax,0
.zero:		cmp dword [esi],0
		je .ok1
		add esi,4
		dec ecx
		cmp ecx,0
		jne .zero
		mov esi,[ebp+8]
		mov edx,4
.repeat1:	mov ecx,3
.again1:	mov ebx,[esi]
		cmp ebx,[esi+4]
		je .ok1
		add esi,4
		dec ecx
		cmp ecx,0
		jne .again1
		add esi,4
		cmp edx,0
		je .next
		dec edx
		jmp .repeat1
.ok1:		mov eax,1
		pop edx
		pop ebx
		pop ecx
		pop esi
		mov esp,ebp
		pop ebp
		ret
.next:		mov esi,[ebp+8]
		push esi
		call trans_matrix
		pop esi
		mov edx,4
.repeat2:       mov ecx,3
.again2:        mov ebx,[esi]
                cmp ebx,[esi+4]
                je .ok2
                add esi,4
                dec ecx
		cmp ecx,0
		jne .again2
                add esi,4
                cmp edx,0
                je .exit
                dec edx
                jmp .repeat2
.ok2:           mov eax,1
.exit:		mov esi,[ebp+8]
		push esi
		call trans_matrix
		add esp,4
                pop edx
                pop ebx
                pop ecx
                pop esi
                mov esp,ebp
                pop ebp
                ret

