section .data
    ; The three boundary test addresses required by the lab manual
    test_addrs dd 0x00000000, 0x0000001F, 0x80001FE0
    num_tests  equ 3
    
    ; Format string to print the Address and its extracted Tag, Index, and Offset
    fmt db "Addr: 0x%08X -> Tag: 0x%05X, Index: 0x%02X, Offset: 0x%02X", 10, 0

section .text
    global _main                    ; Windows MinGW entry point
    extern _printf                  ; Import printf to show output

_main:
    mov esi, test_addrs             ; Pointer to the array of test addresses
    mov ecx, num_tests              ; Set loop counter to 3

extraction_loop:
    push ecx                        ; Save ECX because printf will overwrite it
    mov eax, dword [esi]            ; Load the current memory address into EAX (r0)

    ; 1. Extract Block Offset (bits 4:0) into EBX (r1)
    mov ebx, eax
    and ebx, 0x1F                   ; Mask with 0001_1111b (31) to isolate bottom 5 bits

    ; 2. Extract Set Index (bits 11:5) into EDI (r2)
    mov edi, eax
    shr edi, 5                      ; Shift right by 5 to drop the offset bits
    and edi, 0x7F                   ; Mask with 0111_1111b (127) to isolate the 7 set bits

    ; 3. Extract Tag (bits 31:12) into EDX (r3)
    mov edx, eax
    shr edx, 12                     ; Shift right by 12. Upper 20 bits become the tag.
                                    ; No mask needed since standard shr fills high bits with 0.

    ; =======================================================
    ; Print the results
    ; Arguments are pushed right-to-left for printf
    ; =======================================================
    push ebx                        ; 5th arg: Offset
    push edi                        ; 4th arg: Index
    push edx                        ; 3rd arg: Tag
    push eax                        ; 2nd arg: Original Address
    push fmt                        ; 1st arg: Format string
    call _printf
    add esp, 20                     ; Clean up the stack (5 args * 4 bytes = 20)

    add esi, 4                      ; Move pointer to the next test address
    pop ecx                         ; Restore loop counter
    loop extraction_loop            ; Repeat for all 3 addresses

    ; --- Windows Exit Routine ---
    xor eax, eax                    ; Return 0 (success)
    ret                             ; Return control to C runtime