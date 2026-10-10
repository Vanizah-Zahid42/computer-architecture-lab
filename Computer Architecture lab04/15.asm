section .data
    msg_taken db "Branch is TAKEN", 10, 0
    msg_not_taken db "Branch is NOT TAKEN", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R1 = 10
    mov eax, 10

    ; R2 = 10
    mov ebx, 10

    ; Compare R1 and R2
    cmp eax, ebx

    ; BEQ R1, R2, TARGET
    je TARGET

    ; This runs if values are not equal
    push msg_not_taken
    call _printf
    add esp, 4
    jmp EXIT

TARGET:

    ; This runs because R1 == R2
    push msg_taken
    call _printf
    add esp, 4

EXIT:

    xor eax, eax
    ret