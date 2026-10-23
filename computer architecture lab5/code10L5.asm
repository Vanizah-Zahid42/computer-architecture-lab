section .data
    ; Emulated Cache (8 entries)
    ; Format: Valid Status (4 bytes), Tag (4 bytes)
    cache_array:
        dd 1, 0x1000  ; Entry 0: Valid, Tag=0x1000
        dd 1, 0x2000  ; Entry 1: Valid, Tag=0x2000
        dd 0, 0x0000  ; Entry 2: Invalid (Empty)
        dd 1, 0x3000  ; Entry 3: Valid, Tag=0x3000
        dd 0, 0x0000  ; Entry 4: Invalid (Empty)
        dd 1, 0x4000  ; Entry 5: Valid, Tag=0x4000
        dd 0, 0x0000  ; Entry 6: Invalid (Empty)
        dd 1, 0x5000  ; Entry 7: Valid, Tag=0x5000

    target_tag equ 0x3000       ; CHANGE THIS to test hit vs. miss branches
    
    msg_hit  db "CACHE HIT! Tag 0x%04X found at entry %d.", 10, 0
    msg_miss db "CACHE MISS! Tag 0x%04X not found in any valid entry.", 10, 0

section .text
    global _main                ; Windows MinGW entry point
    extern _printf              ; Import printf

_main:
    mov edx, target_tag         ; EDX = The tag we are searching for
    mov esi, cache_array        ; ESI = Base address of cache array
    mov ecx, 8                  ; ECX = Loop counter (8 max entries)
    xor ebx, ebx                ; EBX = Entry index tracker (0 to 7)

search_loop:
    ; 1. Check validity status (first 4 bytes of the entry)
    mov eax, dword [esi]
    cmp eax, 1                  ; Is Valid == 1?
    jne next_entry              ; If invalid, skip to the next entry

    ; 2. Check Tag (next 4 bytes of the entry)
    mov eax, dword [esi + 4]
    cmp eax, edx                ; Does the entry's tag == our target tag?
    je cache_hit                ; If yes, branch to HIT handler

next_entry:
    add esi, 8                  ; Stride to next entry (4 bytes valid + 4 bytes tag)
    inc ebx                     ; Increment index tracker
    loop search_loop            ; Decrement ECX and repeat if > 0

cache_miss:
    ; =======================================================
    ; MISS HANDLER
    ; =======================================================
    push edx                    ; 2nd arg: Tag searched
    push msg_miss               ; 1st arg: Format string
    call _printf
    add esp, 8                  ; Clean stack
    jmp end_prog                ; Jump to end so we don't accidentally execute the HIT block

cache_hit:
    ; =======================================================
    ; HIT HANDLER
    ; =======================================================
    push ebx                    ; 3rd arg: Index where found
    push edx                    ; 2nd arg: Tag searched
    push msg_hit                ; 1st arg: Format string
    call _printf
    add esp, 12                 ; Clean stack

end_prog:
    ; --- Windows Exit Routine ---
    xor eax, eax                ; Return 0
    ret                         ; Return control to C runtime