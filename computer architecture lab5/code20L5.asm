section .bss
    ; To test L1 limits, use 16KB. To test L2 limits, recompile with 512KB.
    WORKING_SET_SIZE equ 32768
    array resb WORKING_SET_SIZE

section .data
    fmt db "Hierarchy Threshold traverse complete.", 10, 0

section .text
    global _main
    extern _printf

_main:
    ; Assume 'array' is pre-initialized with randomized pointers (done in C/setup phase)
    ; Traversal Loop
    mov ecx, 10000
    mov ebx, array

traverse_loop:
    mov ebx, dword [ebx]        ; Dereference random pointer
    loop traverse_loop

    push fmt
    call _printf
    add esp, 4
    xor eax, eax
    ret