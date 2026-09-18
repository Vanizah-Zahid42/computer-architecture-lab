global _main
extern _printf

section .data
    format db "After DEC, EBX = %d", 10, 0

section .text
_main:
    push ebx

    mov ebx, 10
    dec ebx

    push ebx
    push format
    call _printf
    add esp, 8

    pop ebx

    xor eax, eax
    ret