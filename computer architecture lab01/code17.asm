global _main
extern _printf

section .data
    number db 0
    format db "Value loaded into BL = %d", 10, 0

section .text
_main:
    push ebx

    mov byte [number], 42

    mov bl, byte [number]
    movzx eax, bl

    push eax
    push format
    call _printf
    add esp, 8

    pop ebx

    xor eax, eax
    ret