; Task 1: RAW Dependency
; R1 = R2 + R3
; R4 = R1 - R5

section .data
    msg db "R1 = %d, R4 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:
    mov eax, 10        ; R2 = 10
    mov ebx, 5         ; R3 = 5
    add eax, ebx       ; R1 = R2 + R3 = 15

    mov ecx, 20        ; R5 = 20
    mov edx, eax       ; R1 value
    sub edx, ecx       ; R4 = R1 - R5 = -5

    push edx           ; R4
    push eax           ; R1
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret