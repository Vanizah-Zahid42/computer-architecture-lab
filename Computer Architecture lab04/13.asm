section .data
    array dd 10, 20
    msg db "First = %d, Second = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R3, 0(R2)
    mov eax, [array]          ; First value = 10

    ; LW R4, 4(R2)
    mov ebx, [array + 4]      ; Second value = 20

    ; SW R3, 4(R2)
    mov [array + 4], eax

    ; SW R4, 0(R2)
    mov [array], ebx

    ; Print swapped values
    push dword [array + 4]
    push dword [array]
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret