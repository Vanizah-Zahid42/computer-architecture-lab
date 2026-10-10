section .data
    value dd 0

    msg_taken db "Branch taken: R1 = 0", 10, 0
    msg_not_taken db "Branch not taken: R1 is not 0", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R1, 0(R2)
    mov eax, [value]        ; R1 = 0

    ; Two pipeline stalls
    nop
    nop

    ; BEQ R1, R0, TARGET
    cmp eax, 0
    je TARGET

    ; Branch not taken
    push msg_not_taken
    call _printf
    add esp, 4
    jmp DONE

TARGET:

    ; Branch taken
    push msg_taken
    call _printf
    add esp, 4

DONE:

    xor eax, eax
    ret