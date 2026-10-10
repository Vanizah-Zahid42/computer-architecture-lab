section .data
    value dd 100
    msg db "R1 = %d, R3 = %d, R6 = %d, R9 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R1, 0(R2)
    mov eax, [value]       ; R1 = 100

    ; ADD R3, R4, R5
    mov ebx, 10
    mov ecx, 20
    add ebx, ecx            ; R3 = 30

    ; SUB R6, R7, R8
    mov ecx, 50
    mov edx, 15
    sub ecx, edx            ; R6 = 35

    ; AND R9, R10, R11
    mov edx, 12
    mov esi, 10
    and edx, esi            ; R9 = 8

    ; Print
    push edx
    push ecx
    push ebx
    push eax
    push msg
    call _printf
    add esp, 20

    xor eax, eax
    ret