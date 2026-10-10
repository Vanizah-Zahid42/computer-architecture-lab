section .data
    valueA dd 100
    valueB dd 200
    msg db "R1 = %d, R6 = %d, R2 = %d, R7 = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R1, 0(R4)
    mov eax, [valueA]       ; R1 = 100

    ; LW R6, 4(R4)
    mov ebx, [valueB]       ; R6 = 200

    ; ADD R2, R1, R5
    mov ecx, 10
    add eax, ecx             ; R2 = 110

    ; ADD R7, R6, R8
    mov ecx, 20
    add ebx, ecx             ; R7 = 220

    ; Print
    push ebx
    push eax
    push dword 200
    push dword 100
    push msg
    call _printf
    add esp, 20

    xor eax, eax
    ret