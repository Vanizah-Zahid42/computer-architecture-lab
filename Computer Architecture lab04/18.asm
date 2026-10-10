section .data
    msg db "Counter = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R1 = 3
    mov eax, 3

LOOP:

    ; Simulate useful instruction
    sub eax, 1

    ; Continue until counter becomes zero
    cmp eax, 0
    jne LOOP

    ; Print final counter
    push eax
    push msg
    call _printf
    add esp, 8

    xor eax, eax
    ret