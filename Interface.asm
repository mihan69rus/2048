%include "Often_use_macro.2048"

global write_interface
extern num_in_string

section .data

stick_1		db "_"
stick_2		db "|"
window		db " <--- Write your commands(only 20)"
window_len	equ $-window
some_text	db "Hi, this is game '2048'",10,"by Misha Mestesky.",10,"The rules of this game",10,"are identical to ",10,"the rules of the ",10,"original game. For ",10,"moving write commands",10,"and press 'ENTER'.",10,"Commands: ",10,"h - move left",10,"j - move down",10,"k - move up",10,"l - move right",10,"And:",10,"s - save the position",10,"e - exit",10
text_len	equ $-some_text

section .text

;This procedure write all interface of the game.
;No parameters.

write_interface:
		push ebp
		mov ebp,esp
		sub esp,8
		push ecx
		push eax
		push edx
		push ebx
		push edi
		mov dword [ebp-4],1
		mov dword [ebp-8],2
.write1:	GOTOXY [ebp-4],[ebp-8]
		KERNEL 4,1,stick_1,1
		mov ebx,[ebp-8]
		inc ebx
		mov [ebp-8],ebx
		cmp dword [ebp-8],22
		jne .write1
		cmp dword [ebp-4],1
		jne .ok1
		GOTOXY 2,1
		KERNEL 4,1,stick_2,1
		GOTOXY 3,1
		KERNEL 4,1,stick_2,1
		GOTOXY 2,22
		KERNEL 4,1,stick_2,1
		GOTOXY 3,22
		KERNEL 4,1,stick_2,1
		mov dword [ebp-4],3
		mov dword [ebp-8],2
		jmp .write1
.ok1:		GOTOXY 2,25
		KERNEL 4,1,window,window_len
		mov dword [ebp-4],9
		mov dword [ebp-8],26
.write2:	GOTOXY [ebp-4],[ebp-8]
		KERNEL 4,1,stick_1,1
		mov ebx,[ebp-8]
		inc ebx
		mov [ebp-8],ebx
		cmp dword [ebp-8],50
		jne .write2
		cmp dword [ebp-4],9
		jne .ok2
		mov dword [ebp-4],20
		mov dword [ebp-8],25
		jmp .write2
.ok2:		mov dword [ebp-4],10
		mov dword [ebp-8],25
.write3:	GOTOXY [ebp-4],[ebp-8]
		KERNEL 4,1,stick_2,1
		mov ebx,[ebp-4]
		inc ebx
		mov [ebp-4],ebx
		cmp dword [ebp-4],21
		jne .write3
		cmp dword [ebp-8],25
		jne .ok3
		mov dword [ebp-4],10
		mov dword [ebp-8],50
		jmp .write3
.ok3:		GOTOXY 9,1
		KERNEL 4,1,some_text,text_len
		pop edi
		pop ebx
		pop edx
		pop eax
		pop ecx
		mov esp,ebp
		pop ebp
		ret
