section .bss
    hot_var resd 1
    cold_arr resd 50000

section .data
    fmt db "Write-Back vs Write-Through test complete.", 10, 0

section .text
    global _main
    extern _printf

_main:
    ; 1. Write-Back Absorption (Continuous stores to single address)
    mov ecx, 50000
    mov esi, hot_var
wb_loop:
    mov dword [esi], ecx
    loop wb_loop

    ; 2. Store Queue Saturation (Stores to 50,000 dispersed addresses)
    mov ecx, 50000
    mov edi, cold_arr
wt_loop:
    mov dword [edi], ecx
    add edi, 4
    loop wt_loop

    push fmt
    call _printf
    add esp, 4
    xor eax, eax
    ret