section .data
    msg db "R2 = %d, R6 = %d, R9 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R2 = R4 + R5
    mov eax, 10
    mov ebx, 5
    add eax, ebx        ; R2 = 15

    ; R6 = R7 AND R8
    mov ecx, 12
    mov edx, 10
    and ecx, edx        ; R6 = 8

    ; One NOP
    nop

    ; R9 = R2 OR R10
    mov edx, 2
    or edx, eax         ; R9 = 15

    ; Print
    push edx
    push ecx
    push eax
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret