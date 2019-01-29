%include "asm_io.inc"

section .data
errmsg:  db "incorrect number of command line arguments",0
errmsg2: db "incorrect command line argument",0

init:    db "      initial configuration",0
final:   db "       final configuration",0

o1:      db "                o|o          ",0
o2:      db "               oo|oo         ",0
o3:      db "              ooo|ooo        ",0
o4:      db "             oooo|oooo       ",0
o5:      db "            ooooo|ooooo      ",0
o6:      db "           oooooo|oooooo     ",0
o7:      db "          ooooooo|ooooooo    ",0
o8:      db "         oooooooo|oooooooo   ",0
o9:      db "        ooooooooo|ooooooooo  ",0
XX:      db "      XXXXXXXXXXXXXXXXXXXXXXX",0

section .bss
NUM: resd 1
PEG: resd 9

section .text
	global asm_main

showp:
  enter 0,0
  pusha

  mov ebx, [ebp+8]
  mov ecx, 0

  L2:
    cmp ecx, [ebp+12]
    jae L3
    mov eax, [ebx]
  
    cmp eax, dword 1
    je O1
    cmp eax, dword 2
    je O2
    cmp eax, dword 3
    je O3
    cmp eax, dword 4
    je O4
    cmp eax, dword 5
    je O5
    cmp eax, dword 6
    je O6
    cmp eax, dword 7
    je O7
    cmp eax, dword 8
    je O8
    jmp O9

    O1: mov eax, o1
        jmp G1
    O2: mov eax, o2
        jmp G1
    O3: mov eax, o3
        jmp G1
    O4: mov eax, o4
        jmp G1
    O5: mov eax, o5
        jmp G1
    O6: mov eax, o6
        jmp G1
    O7: mov eax, o7
        jmp G1
    O8: mov eax, o8
        jmp G1
    O9: mov eax, o9
    
    G1:
    call print_string
    call print_nl

    mov eax, [ebx]
    add ebx, 4
    inc ecx
    jmp L2

  L3:
  mov eax, XX
  call print_string
  call print_nl

  popa  
  leave
  ret


sorthem:
  enter 0,0
  pusha 
  
  mov ebx, [ebp+8]
  mov esi, [ebp+12]

  cmp esi, dword 1
  je SE
  
  dec esi
  push esi
  add ebx, 4
  push ebx
  call sorthem
  pop ebx
  pop esi

  mov ebx, [ebp+8]
  mov ecx, ebx
  add ebx, 4
  mov esi, [ebp+12]
  dec esi
  
  mov edx, dword 0
  L:
   cmp edx, esi
   je LE
   mov eax, [ecx]
   cmp eax, [ebx]
   ja LE 

   mov eax, [ebx]
   mov edi, [ecx]
   mov [ebx], edi
   mov [ecx], eax 
  
   inc edx  
   add ecx, 4
   add ebx, 4
   jmp L

  LE:
   mov eax, [NUM] 
   push eax
   mov eax, PEG
   push eax
   call showp
   pop eax
   pop eax
   call read_char

  SE:
  popa
  leave
  ret


asm_main:
  enter 0,0

  mov eax, dword [ebp+8]
  cmp eax, 2
  jne E1

  S1:
  mov ebx, dword [ebp+12]
  mov ecx, dword [ebx+4]
  cmp byte[ecx], byte 0
  je E2
  cmp byte[ecx+1], byte 0
  jne E2
  
  L1:
   cmp byte[ecx], '2'
   jb E2
   cmp byte[ecx], '9'
   ja E2

   mov al, byte [ecx]
   sub eax, dword '0'
   mov [NUM], eax
   mov eax, [NUM]
   push eax
   mov eax, PEG
   push eax
   call rconf

   call print_nl
   mov eax, init
   call print_string 
   call print_nl
   call print_nl

   mov eax, [NUM]
   push eax
   mov eax, PEG
   push eax
   call showp
   call read_char

   mov eax, [NUM]
   push eax
   mov eax, PEG
   push eax
   call sorthem

   mov eax, final
   call print_string
   call print_nl
   call print_nl

   mov eax, [NUM]
   push eax
   mov eax, PEG
   push eax
   call showp

   jmp END

  E1:
   mov eax, errmsg
   call print_string
   call print_nl
   jmp END

  E2:
   mov eax, errmsg2
   call print_string
   call print_nl
   jmp END

  END:
   leave
   ret
