section .data
    msg db "R1 = %d, R2 = %d, R7 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R1 = R3 + R4
    mov eax, 10
    mov ebx, 5
    add eax, ebx        ; R1 = 15

    ; R2 = R5 + R6
    mov ecx, 20
    mov edx, 7
    add ecx, edx        ; R2 = 27

    ; Two pipeline stalls
    nop
    nop

    ; R7 = R1 + R2
    mov edx, eax
    add edx, ecx        ; R7 = 42

    ; Print
    push edx
    push ecx
    push eax
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret