global _main
extern _printf

section .data
    format db "30 - 10 = %d", 10, 0

section .text
_main:
    push ebx

    mov eax, 30
    mov ebx, 10

    sub eax, ebx

    push eax
    push format
    call _printf
    add esp, 8

    pop ebx

    xor eax, eax
    ret