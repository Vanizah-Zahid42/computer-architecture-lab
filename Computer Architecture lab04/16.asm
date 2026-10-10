section .data
    msg db "R1 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R4 = 10
    mov eax, 10

    ; R5 = 10
    mov ebx, 10

    ; Branch condition
    cmp eax, ebx

    ; BEQ R4, R5, TARGET
    je TARGET

    ; Delay slot instruction
    ; Safe independent instruction
    mov ecx, 20
    add ecx, 5             ; R1 = 25

TARGET:

    ; Print result
    push ecx
    push msg
    call _printf
    add esp, 8

    xor eax, eax
    ret