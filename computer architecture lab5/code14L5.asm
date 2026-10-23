section .bss
    BLOCK_DIST equ 8192
    mem_pool resb BLOCK_DIST * 3

section .data
    fmt db "FIFO/LRU Divergence trace completed.", 10, 0

section .text
    global _main
    extern _printf

_main:
    mov esi, mem_pool               ; A
    mov edi, mem_pool
    add edi, BLOCK_DIST             ; B
    mov ebx, mem_pool
    add ebx, BLOCK_DIST * 2         ; C

    ; Execute Stream: [A, B, A, C, A, B] (This specific sequence highlights the divergence)
    mov eax, dword [esi]            ; A
    mov eax, dword [edi]            ; B
    mov eax, dword [esi]            ; A
    mov eax, dword [ebx]            ; C
    mov eax, dword [esi]            ; A
    mov eax, dword [edi]            ; B

    push fmt
    call _printf
    add esp, 4
    xor eax, eax
    ret