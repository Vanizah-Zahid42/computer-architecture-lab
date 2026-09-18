global _main
extern _printf

section .data
    format db "AL = %d, BL = %d", 10, 0

section .text
_main:
    push ebx

    mov al, 10
    mov bl, al

    movzx ecx, bl
    movzx eax, al

    push ecx
    push eax
    push format
    call _printf
    add esp, 12

    pop ebx

    xor eax, eax
    ret