section .data
    value dd 100
    msg db "Loaded value = %d, R3 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R1, 0(R2)
    mov eax, [value]     ; R1 = 100

    ; One-cycle stall
    nop

    ; R3 = R1 + R4
    mov ebx, 20
    add eax, ebx         ; R3 = 120

    push eax
    push dword 100
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret