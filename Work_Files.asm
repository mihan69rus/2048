%include "Often_use_macro.2048"

%ifdef OS_FREEBSD
	openwr_flags		equ 601h
%else
 	openwr_flags		equ 241h
%endif

global string_in_num
global save_record
global look_record
global save_matrix
global load_matrix

extern	reverce_string
extern 	num_in_string

section .bss

forread		resb 20
forwrite	resb 20
for_name	resb 22

section .data


best		db "Best result:",10
best_len	equ $-best
final		db "Game over.",10,"Enter your name for record(only 20 symbols):",10
final_len	equ $-final
umaska		equ 0666q
text_name	db ".Record.txt",0
matrix_s	db ".RecordM.txt",0
enter_f		db 10
error_n		db "Man who cant read",10
er_len		equ $-error_n
error_load	db "Sorry, no save. Please start new.",10
error_load_len 	equ $-error_load

section .text

;Transform string in number. Parameters - pointer on string,
;which should transform.
;Parameters will get from stack. Results will be in eax.
;1 paramater: pointer on string.
;At first this procedure reverce string then multiply on 10^n,
;where n - number of digit.
;At finish this procedure reverce string again.
;eax = result.

string_in_num:  push ebp
                mov ebp,esp
                push esi
                push edi
                push ebx
                push ecx
                push edx
		xor eax,eax
                mov edi,0
                mov ebx,1
                mov ecx,10
                mov esi,[ebp+8]
                push esi
                call reverce_string
                add esp,4
.again_mul:     xor edx,edx
                cmp byte [esi],0
                je .exit
                mov al,[esi]
                sub al,"0"
                mul ebx
                add edi,eax
                mov eax,ebx
                mul ecx
                mov ebx,eax
                xor eax,eax
                inc esi
                jmp .again_mul
.exit:          mov esi,[ebp+8]
                push esi
                call reverce_string
                add esp,4
                mov eax,edi
                pop edx
                pop ecx
                pop ebx
                pop edi
                pop esi
                mov esp,ebp
                pop ebp
                ret

;This procedure save your score if it more then record
;in file 'Records.txt'. Parameter get from ebx.
;1 parameter: score in ebx.
;Break nothing.

save_record:	mov byte [for_name],0
		push ebp
		mov ebp,esp
		sub esp,8
		push eax
		push ebx
		push edx
		push ecx
		push esi
		push edi
		KERNEL 5,text_name,0h
		cmp eax,-1
		je .write2
		mov [ebp-4],eax			;[ebp-4]=descriptor of file
		mov dword [ebp-8],forread	;[ebp-8]=byte for read
		mov esi,[ebp-8]
.read:		KERNEL 3,[ebp-4],[ebp-8],1
		mov esi,[ebp-8]
		cmp byte [esi],10
		je .after
		inc esi
		mov [ebp-8],esi
		jmp .read
.after:		mov byte [esi],0
		push forread
		call string_in_num
		add esp,4
		cmp eax,ebx
		ja .close
.write:		KERNEL 6,[ebp-4]
.write2:	KERNEL 5,text_name,openwr_flags,umaska
		mov [ebp-4],eax
		mov esi,forwrite
		mov eax,ebx
		push esi
		call num_in_string
		add esp,4
		KERNEL 4,[ebp-4],forwrite,ecx
		KERNEL 4,[ebp-4],enter_f,1
		CLEAR
		GOTOXY 1,1
		KERNEL 4,1,final,final_len
.again:		KERNEL 3,0,for_name,21
		cmp eax,1
		je .again
		cmp eax,21
		jne .name
		KERNEL 4,[ebp-4],error_n,er_len
		jmp .close
.name:		KERNEL 4,[ebp-4],for_name,eax
.close:		KERNEL 6,[ebp-4]
		pop edi
		pop esi
		pop ecx
		pop edx
		pop ebx
		pop eax
		mov esp,ebp
		pop ebp
		ret

;This procedure output you a best result.
;No parameters.
;Break nothing.

look_record:	push ebp
		mov ebp,esp
		sub esp,4
		push eax
		push ecx
		push edx
		KERNEL 5,text_name,0
		cmp eax,-1
		je .exit
		mov [ebp-4],eax
		KERNEL 4,1,best,best_len
		KERNEL 3,[ebp-4],for_name,21
		KERNEL 4,1,for_name,eax
		KERNEL 3,[ebp-4],for_name,21
		KERNEL 4,1,for_name,eax
		KERNEL 6,[ebp-4]
.exit:		pop edx
		pop ecx
		pop eax
		mov esp,ebp
		pop ebp
		ret

;This procedure save current matrix and score
;from ebx in file.
;1 parameterL pointer on string.
;Break nothing.

save_matrix:	push ebp
		mov ebp,esp
		sub esp,4
		push esi
		push eax
		push ecx
		push edi
		push edx
		mov edi,0
		mov esi,[ebp+8]
		KERNEL 5,matrix_s,openwr_flags,umaska
		mov [ebp-4],eax
.again:		mov eax,[esi]
		push forwrite
		call num_in_string
		add esp,4
		KERNEL 4,[ebp-4],forwrite,ecx
		KERNEL 4,[ebp-4],enter_f,1
		inc edi
		add esi,4
		cmp edi,16
		jne .again
		mov eax,ebx
		push forwrite
		call num_in_string
		add esp,4
		KERNEL 4,[ebp-4],forwrite,ecx
		KERNEL 4,[ebp-4],enter_f,1
		KERNEL 6,[ebp-4]
		pop edx
		pop edi
		pop ecx
		pop eax
		pop esi
		mov esp,ebp
		pop ebp
		ret

;Move matrix from file to matrix. And score in ebx.
;1 parameter: pointer on matrix.
;ebx=score.

load_matrix:	push ebp
		mov ebp,esp
		sub esp,8
		push esi
		push eax
		push edi
		mov ebx,0
		mov esi,[ebp+8]
		KERNEL 5,matrix_s,000h
		cmp eax,-1
		je .error
		mov [ebp-4],eax
.again:		mov dword [ebp-8],forread
.read:		KERNEL 3,[ebp-4],[ebp-8],1
		mov edi,[ebp-8]
		cmp byte [edi],0
		je .exit
		cmp byte [edi],10
		je .load
		inc edi
		mov [ebp-8],edi
		jmp .read
.load:		mov dword [edi],0
		inc ebx
		cmp ebx,17
		je .load_ebx
		push forread
		call string_in_num
		add esp,4
		mov [esi],eax
		add esi,4
		jmp .again
.error:		CLEAR
		GOTOXY 1,1
		KERNEL 4,1,error_load,error_load_len
		EXIT
.load_ebx:	push forread
		call string_in_num
		add esp,4
		mov ebx,eax
.exit:		KERNEL 6,[ebp-4]
		pop edi
		pop eax
		pop esi
		mov esp,ebp
		pop ebp
		ret
