section .bss
    ; Assuming a target L1 cache size of 32 KB
    CACHE_SIZE equ 32768
    ; Allocate enough memory to space 5 variables apart by CACHE_SIZE
    memory_block resb CACHE_SIZE * 5

section .data
    fmt db "Threshold test completed for K=5.", 10, 0

section .text
    global _main                        ; Windows MinGW entry point
    extern _printf                      ; Import printf

_main:
    mov ecx, 1000                       ; Set loop counter for traversal

    ; Initialize pointers P1 through P5, all spaced CACHE_SIZE apart
    mov esi, memory_block               ; P1
    
    mov edi, memory_block
    add edi, CACHE_SIZE                 ; P2
    
    mov ebx, memory_block
    add ebx, CACHE_SIZE * 2             ; P3
    
    mov edx, memory_block
    add edx, CACHE_SIZE * 3             ; P4

    ; Since we are out of general registers for base addresses, 
    ; we will calculate P5's address dynamically in the loop

threshold_loop:
    ; Read from P1
    mov eax, dword [esi]
    
    ; Read from P2
    mov eax, dword [edi]
    
    ; Read from P3
    mov eax, dword [ebx]
    
    ; Read from P4
    mov eax, dword [edx]

    ; Read from P5 (Calculate P5's address using ESI as a base)
    mov eax, esi
    add eax, CACHE_SIZE * 4
    mov eax, dword [eax]

    loop threshold_loop                 ; Decrement ECX and repeat 1000 times

    ; =======================================================
    ; Print the results
    ; =======================================================
    push fmt                            ; Push format string pointer
    call _printf
    add esp, 4                          ; Clean up stack (1 arg * 4 bytes)

    ; --- Windows Exit Routine ---
    xor eax, eax                        ; Return 0 (success)
    ret                                 ; Return control to C runtime