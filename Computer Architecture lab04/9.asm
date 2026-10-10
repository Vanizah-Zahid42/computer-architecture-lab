section .data
    result dd 0
    msg db "R4 = %d, Memory = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R4 = R2 + R3
    mov eax, 10
    mov ebx, 20
    add eax, ebx         ; R4 = 30

    ; SW R4, 0(R5)
    mov [result], eax    ; Store R4 into memory

    ; Print
    push dword [result]
    push eax
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret