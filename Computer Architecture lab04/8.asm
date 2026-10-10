section .data
    value1 dd 100
    value2 dd 200
    msg db "R1 = %d, R3 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; First load
    mov eax, value1      ; R1 = 100

    ; Required stall
    nop

    ; Second load
    mov ebx, value2      ; R3 = 200

    ; Print
    push ebx
    push eax
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret