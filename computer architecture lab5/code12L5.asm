section .data
    fmt db "Addr: 0x%08X | Raw Index: 0x%02X | Hashed Index: 0x%02X", 10, 0
    STRIDE equ 1024                     ; Pathological stride

section .text
    global _main                        ; Windows MinGW entry point
    extern _printf                      ; Import printf

_main:
    mov ecx, 5                          ; Run 5 iterations to observe the mapping
    mov esi, 0x00001000                 ; Arbitrary starting physical address

hash_loop:
    push ecx                            ; Save loop counter
    mov eax, esi                        ; EAX holds the current physical address

    ; 1. Extract Raw Index (Assume bits 11:5 for a 4KB cache, 7 bits total)
    mov ebx, eax
    shr ebx, 5
    and ebx, 0x7F                       ; EBX = Index_raw

    ; 2. Extract Tag (Bits 31:12)
    mov edx, eax
    shr edx, 12                         ; EDX = Tag

    ; 3. Compute Hashed Index = Index_raw XOR (Tag & Mask)
    mov edi, edx
    and edi, 0x7F                       ; Apply 7-bit mask to the Tag
    xor edi, ebx                        ; EDI = Index_hashed

    ; =======================================================
    ; Print the results
    ; =======================================================
    push edi                            ; 3rd arg: Hashed Index
    push ebx                            ; 2nd arg: Raw Index
    push esi                            ; 1st arg: Original Address
    push fmt                            ; Format string
    call _printf
    add esp, 16                         ; Clean up stack (4 args * 4 bytes)

    add esi, STRIDE                     ; Advance address by exactly 1024 bytes
    pop ecx
    loop hash_loop

    ; --- Windows Exit Routine ---
    xor eax, eax                        ; Return 0
    ret