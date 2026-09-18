global _main
extern _printf

section .data
    format db "EAX = %d, EBX = %d", 10, 0

section .text
_main:
    push ebx

    mov eax, 10
    mov ebx, 20

    add eax, ebx

    push ebx
    push eax
    push format
    call _printf
    add esp, 12

    pop ebx

    xor eax, eax
    ret