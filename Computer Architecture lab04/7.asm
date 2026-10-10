section .data
    value dd 100
    msg db "R1 = %d, R5 = %d, R3 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R1, 0(R2)
    mov eax, [value]     ; R1 = 100

    ; Independent instruction
    mov ebx, 20
    mov ecx, 8
    sub ebx, ecx         ; R5 = 12

    ; ADD R3, R1, R4
    mov ecx, 5
    add eax, ecx         ; R3 = 105

    ; Print
    push eax
    push ebx
    push dword 100
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret