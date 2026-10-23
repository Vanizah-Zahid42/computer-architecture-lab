section .bss
    CACHE_SIZE equ 8192                 ; 8 KB Direct-Mapped Cache Size
    ; Allocate enough memory to place P1 at the beginning and P2 exactly 8KB away
    memory_block resb CACHE_SIZE + 4    

section .data
    fmt db "Thrashing loop completed! Alternated 2000 times.", 10, 0

section .text
    global _main                        ; Windows MinGW entry point
    extern _printf                      ; Import printf

_main:
    mov ecx, 2000                       ; Set loop counter to 2000 iterations
    mov esi, memory_block               ; P1: Base address
    mov edi, memory_block   
    add edi, CACHE_SIZE                 ; P2: Base address + 8192 bytes

    xor eax, eax                        ; Clear accumulator

thrash_loop:
    mov edx, dword [esi]                ; LOAD from P1
    add eax, edx                        ; Dummy operation
    
    mov edx, dword [edi]                ; LOAD from P2
    add eax, edx                        ; Dummy operation
    
    loop thrash_loop                    ; Decrement ECX and repeat 2000 times

    ; =======================================================
    ; Print the results to verify successful execution
    ; =======================================================
    push fmt                            ; Push format string pointer
    call _printf
    add esp, 4                          ; Clean up stack (1 arg * 4 bytes)

    ; --- Windows Exit Routine ---
    xor eax, eax                        ; Return 0 (success)
    ret                                 ; Return control to C runtime