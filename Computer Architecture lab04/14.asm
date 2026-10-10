section .data
    X dd 4, 6
    Y dd 5, 7
    msg db "X0 = %d, Y0 = %d, X1 = %d, Product = %d, Sum = %d", 10, 0

section .text
    global _main
    extern _printf

_main:

    ; LW R3, 0(R1)
    mov eax, [X]              ; X0 = 4

    ; LW R4, 0(R2)
    mov ebx, [Y]              ; Y0 = 5

    ; LW R5, 4(R1)
    mov ecx, [X + 4]          ; X1 = 6

    ; MUL R6, R3, R4
    mov edx, eax
    imul edx, ebx             ; Product = 20

    ; ADD R10, R10, R6
    mov esi, edx
    add esi, 0                ; Sum = 20

    ; Print
    push esi
    push edx
    push ecx
    push ebx
    push eax
    push msg
    call _printf
    add esp, 24

    xor eax, eax
    ret