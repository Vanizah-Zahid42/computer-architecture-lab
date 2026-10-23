section .bss
    arr resd 10000

section .data
    fmt db "Prefetch loop complete.", 10, 0

section .text
    global _main
    extern _printf

_main:
    mov ecx, 9000
    mov esi, arr
    xor eax, eax

prefetch_loop:
    ; Prefetch data 64 elements (256 bytes) ahead of current pointer
    prefetcht0 [esi + 256]      

    ; Compute current element
    add eax, dword [esi]
    add esi, 4
    loop prefetch_loop

    push fmt
    call _printf
    add esp, 4
    xor eax, eax
    ret