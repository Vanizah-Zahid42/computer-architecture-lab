section .bss
    ; Assuming cache blocks A, B, C are separated by a cache size multiple to force collision
    BLOCK_DIST equ 8192
    mem_pool resb BLOCK_DIST * 3

section .data
    fmt db "LRU Trace stream completed.", 10, 0

section .text
    global _main
    extern _printf

_main:
    mov esi, mem_pool               ; A
    mov edi, mem_pool
    add edi, BLOCK_DIST             ; B
    mov ebx, mem_pool
    add ebx, BLOCK_DIST * 2         ; C

    ; Execute Stream: [A, B, A, C, A, B]
    mov eax, dword [esi]            ; 1. Load A
    mov eax, dword [edi]            ; 2. Load B
    mov eax, dword [esi]            ; 3. Load A
    mov eax, dword [ebx]            ; 4. Load C
    mov eax, dword [esi]            ; 5. Load A
    mov eax, dword [edi]            ; 6. Load B

    push fmt
    call _printf
    add esp, 4

    xor eax, eax
    ret