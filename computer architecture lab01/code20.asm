global _main
extern _printf

section .data
    result db 0
    format db "AL = %d, BL = %d, Memory = %d", 10, 0

section .text
_main:
    push ebx

    ; Step 1: Put 10 into AL
    mov al, 10

    ; Step 2: Add 20
    ; 10 + 20 = 30
    add al, 20

    ; Step 3: Subtract 5
    ; 30 - 5 = 25
    sub al, 5

    ; Step 4: Store AL in memory
    mov byte [result], al

    ; Step 5: Read memory into BL
    mov bl, byte [result]

    ; Convert values to 32-bit integers for printf
    movzx eax, al
    movzx ecx, bl
    movzx edx, byte [result]

    ; printf("AL = %d, BL = %d, Memory = %d",
    ;        AL, BL, Memory);

    ; Push arguments from right to left
    push edx
    push ecx
    push eax
    push format

    call _printf
    add esp, 16

    pop ebx

    xor eax, eax
    ret