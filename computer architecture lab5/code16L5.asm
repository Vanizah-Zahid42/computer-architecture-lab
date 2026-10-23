section .bss
    uncached_var resd 1

section .data
    fmt db "Write Allocate verification complete.", 10, 0

section .text
    global _main
    extern _printf

_main:
    mov esi, uncached_var
    
    ; Flush to ensure it's not in cache
    clflush [esi]
    
    ; 1. Issue Store to un-cached location (Write Miss)
    mov dword [esi], 42
    
    ; 2. Immediately issue Load to same location
    mov eax, dword [esi]

    push fmt
    call _printf
    add esp, 4
    xor eax, eax
    ret