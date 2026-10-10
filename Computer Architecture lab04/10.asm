section .data
    source dd 150
    destination dd 0
    msg db "Loaded = %d, Stored = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R1, 0(R2)
    mov eax, [source]       ; R1 = 150

    ; SW R1, 0(R3)
    ; No NOP required
    mov [destination], eax

    ; Print
    push dword [destination]
    push eax
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret