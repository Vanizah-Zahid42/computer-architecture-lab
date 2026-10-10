section .data
    msg db "Temp1 = %d, Temp2 = %d, Result = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; A = 10, B = 5
    mov eax, 10
    mov ebx, 5
    add eax, ebx          ; Temp1 = 15

    ; C = 20, D = 7
    mov ecx, 20
    mov edx, 7
    add ecx, edx          ; Temp2 = 27

    ; Result = Temp1 + Temp2
    add eax, ecx          ; Result = 42

    ; Print
    push eax
    push ecx
    push dword 15
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret