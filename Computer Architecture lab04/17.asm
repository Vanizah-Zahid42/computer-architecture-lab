section .data
    msg_exit db "Branch taken: R4 = 0", 10, 0
    msg_continue db "Branch not taken: R4 is not zero", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; R4 = 1
    mov eax, 1

    ; R4 = R4 - 1
    sub eax, 1

    ; if R4 == 0 goto EXIT
    cmp eax, 0
    je EXIT

    ; Delay-slot fallback
    nop

    ; If branch is not taken
    push msg_continue
    call _printf
    add esp, 4
    jmp DONE

EXIT:

    push msg_exit
    call _printf
    add esp, 4

DONE:

    xor eax, eax
    ret