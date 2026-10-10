section .data
    msg db "R1 = %d, R4 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R1 = R2 + R3
    mov eax, 10
    mov ebx, 5
    add eax, ebx        ; R1 = 15

    ; Two NOPs = pipeline delay
    nop
    nop

    ; R4 = R1 - R5
    mov ecx, 20
    mov edx, eax
    sub edx, ecx        ; R4 = -5

    ; Print result
    push edx
    push eax
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret