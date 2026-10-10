section .data
    msg db "Final R1 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; Initial R1 = 10
    mov eax, 10

    ; R1 = R1 + R2
    mov ebx, 5
    add eax, ebx        ; R1 = 15

    ; Two NOPs
    nop
    nop

    ; R1 = R1 + R3
    mov ebx, 7
    add eax, ebx        ; R1 = 22

    ; Two NOPs
    nop
    nop

    ; R1 = R1 + R4
    mov ebx, 3
    add eax, ebx        ; R1 = 25

    ; Print final result
    push eax
    push msg
    call _printf
    add esp, 8

    xor eax, eax
    ret