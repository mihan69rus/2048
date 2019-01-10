%include "Often_use_macro.2048"

global _start

extern write_matrix
extern move_right
extern move_down
extern move_left
extern move_up
extern random
extern num_in_string
extern write_interface
extern init_x
extern look_record
extern save_record
extern save_matrix
extern load_matrix
extern ReadX
extern x
extern string_in_num

section .data

count_		db "Score: "
ParamError	db "You must chose only 1 parameter:",10,"'n' - for new game",10,"'l' - for continue saved game",10,"'r' - for see records"
ParamE_len	equ $-ParamError
ParamWrong	db "Wrong parameter, use:",10,"'n' - for new game",10,"'l' - for continue saved game",10,"'r' - for see records"
ParamW_len	equ $-ParamWrong
Wrong_in	db "Sorry, but only 20 symbols. Please be careful.",10
Wrong_in_len	equ $-Wrong_in
Messege		db "Please, expand to fuul screen",10,"And enter number(only 3 digit):",10
Messege_len	equ $-Messege
GameOver	db "Game over",10
GameOver_len	equ $-GameOver

section .bss

matrix		resd 16
massive		resb 21
move_sym	resb 1
for_count	resb 20

section .text
_start:		cmp dword [esp],2
		je get
		CLEAR
		GOTOXY 1,1
		KERNEL 4,1,ParamError,ParamE_len
		ENTER
		EXIT
get:		mov esi,[esp+8]
		cmp byte [esi+1],0
		jne bad
		cmp byte [esi],"n"
		je new
		cmp byte [esi],"r"
		je record
		cmp byte [esi],"l"
		je load
bad:		CLEAR
		GOTOXY 1,1
		KERNEL 4,1,ParamWrong,ParamW_len
		ENTER
		EXIT
new:		CLEAR
		KERNEL 4,1,Messege,Messege_len
		KERNEL 3,0,ReadX,3
		cmp eax,1
		je new
		push ReadX
		call string_in_num
		add esp,4
		mov [x],eax
		CLEAR
		mov edi,1
		xor ebx,ebx
		mov ecx,16
		mov esi,matrix
		xor eax,eax
again:		mov [esi],eax
		add esi,4
		loop again
		mov esi,matrix
		call random
		mov dword [esi+4*eax],2
		call random
		mov dword [esi+4*eax],2
		push matrix
		call write_matrix
		add esp,4
		GOTOXY 2,2
repeat:		call write_interface
		push eax
		push ecx
		mov eax,ebx
		push for_count
		call num_in_string
		add esp,4
		push ecx
		GOTOXY 5,1
		KERNEL 4,1,count_,7
		pop ecx
		KERNEL 4,1,for_count,ecx
		GOTOXY 2,2
		pop ecx
		pop eax
		push ecx
		push eax
		push matrix
		KERNEL 3,0,massive,22
		cmp eax,22
		je bad_in
		mov ebp,eax
		xor esi,esi
		add esp,4
		pop eax
		pop ecx
		push matrix
move_from_mas:	mov al,[massive+esi]
		mov [move_sym],al
		inc esi
		cmp byte [move_sym],"j"
		jne left
		call move_down
		jmp after
left:		cmp byte [move_sym],"h"
		jne right
		call move_left
		jmp after
right:		cmp byte [move_sym],"l"
		jne up
		call move_right
		jmp after
up:		cmp byte [move_sym],"k"
		jne end
		call move_up
after:		CLEAR
		call write_matrix
		cmp edi,0
		je exit
		GOTOXY 2,2
		cmp ebp,esi
		jne move_from_mas
		jmp repeat
end:		cmp byte [move_sym],"e"
		je exit
save:		cmp byte [move_sym],"s"
		jne after
		call save_matrix
		add esp,4
		jmp after
exit:		call save_record
		CLEAR
		GOTOXY 1,1
		KERNEL 4,1,GameOver,GameOver_len
		EXIT
record:		GOTOXY 1,1
		CLEAR
		call look_record
		EXIT
load:		CLEAR
		push matrix
		call load_matrix
		call write_matrix
		add esp,4
		mov edi,1
		jmp repeat
bad_in:		CLEAR
		GOTOXY 1,1
		KERNEL 4,1,Wrong_in,Wrong_in_len
		EXIT
