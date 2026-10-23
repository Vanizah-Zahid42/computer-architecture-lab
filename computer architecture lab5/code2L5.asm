section .bss
    align 16                        ; Ensure 16-byte alignment as requested
    hot_var resd 1                  ; Reserve 1 32-bit variable (4 bytes)

section .data
    fmt db "Final value after 10000 iterations: %d", 10, 0 

section .text
    global _main                    ; Windows MinGW entry point
    extern _printf                  ; Import printf to show output

_main:
    mov dword [hot_var], 0          ; Initialize the variable to 0
    mov ecx, 10000                  ; Set loop counter to 10,000 iterations
    mov esi, hot_var                ; Load the pointer to the hot working set

temporal_loop:
    mov eax, dword [esi]            ; LOAD: Read variable from memory into cache
    inc eax                         ; MODIFY: Increment the value in the CPU register
    mov dword [esi], eax            ; STORE: Write the updated value back
    loop temporal_loop              ; Decrement ECX and repeat 10,000 times

    ; --- Print the result to verify it worked ---
    push eax                        ; EAX contains 10000 after the loop; push it as 2nd arg
    push fmt                        ; Push the format string pointer as 1st arg
    call _printf                    ; Call C standard library printf
    add esp, 8                      ; Clean up the stack (2 arguments * 4 bytes = 8)

    ; --- Windows Exit Routine ---
    xor eax, eax                    ; Return 0 (success)
    ret                             ; Return control to Windows C runtime