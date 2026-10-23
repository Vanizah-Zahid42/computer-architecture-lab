section .bss
    ENTITIES equ 10000              ; 10,000 entities to process
    
    ; 1. Array of Structures (AoS) memory layout
    ; Each struct is 16 bytes (x:4, y:4, tag:1+3 pad, z:4)
    aos_array resb ENTITIES * 16    
    
    ; 2. Structure of Arrays (SoA) memory layout
    ; Attributes are separated into contiguous arrays
    soa_x   resd ENTITIES
    soa_y   resd ENTITIES
    soa_tag resb ENTITIES
    soa_z   resd ENTITIES

section .data
    fmt db "Traversal Complete! AoS Sum: %d, SoA Sum: %d", 10, 0

section .text
    global _main                    ; Windows MinGW entry point
    extern _printf                  ; Import printf to show output

_main:
    ; =======================================================
    ; 1. Traversal using Array of Structures (AoS)
    ; =======================================================
    mov ecx, ENTITIES               ; Loop counter (10,000)
    mov esi, aos_array              ; Base address of AoS
    xor eax, eax                    ; Accumulator for AoS sum

aos_loop:
    add eax, dword [esi]            ; Read attribute 'x' (first 4 bytes of struct)
    add esi, 16                     ; Stride by 16 bytes to the next struct
    loop aos_loop
    
    mov ebx, eax                    ; Save AoS sum into EBX for printing

    ; =======================================================
    ; 2. Traversal using Structure of Arrays (SoA)
    ; =======================================================
    mov ecx, ENTITIES               ; Loop counter (10,000)
    mov esi, soa_x                  ; Base address of the contiguous 'x' array
    xor eax, eax                    ; Accumulator for SoA sum

soa_loop:
    add eax, dword [esi]            ; Read attribute 'x'
    add esi, 4                      ; Stride by 4 bytes (contiguous elements)
    loop soa_loop

    ; =======================================================
    ; Print the results to verify it worked
    ; =======================================================
    push eax                        ; Push 3rd arg (SoA sum from EAX)
    push ebx                        ; Push 2nd arg (AoS sum from EBX)
    push fmt                        ; Push 1st arg (Format string)
    call _printf
    add esp, 12                     ; Clean up stack (3 args * 4 bytes)

    ; --- Windows Exit Routine ---
    xor eax, eax                    ; Return 0 (success)
    ret                             ; Return control to C runtime