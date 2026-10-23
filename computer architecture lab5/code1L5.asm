section .data
    N equ 1024                      ; N = 1024 integers
    array times N dd 1              ; Initialize 1024 32-bit integers (value = 1)
    fmt db "The sum is: %d", 10, 0  ; Format string for printf (10 = newline, 0 = null terminator)

section .text
    global _main                    ; Entry point for MinGW GCC
    extern _printf                  ; Import printf from the C standard library

_main:
    mov ecx, N                      ; Set loop counter to 1024
    mov esi, array                  ; Load base address of the array into ESI
    xor eax, eax                    ; Clear EAX (Accumulator for the sum)

sum_loop:
    add eax, dword [esi]            ; Read memory and add to sum
    add esi, 4                      ; Increment pointer by 4 bytes (32 bits)
    loop sum_loop                   ; Decrement ECX, jump if not zero

    ; --- Print the result ---
    ; At this point, EAX contains the total sum (1024).
    ; We need to pass arguments to printf right-to-left: printf(fmt, eax)
    
    push eax                        ; Push the sum (2nd argument) onto the stack
    push fmt                        ; Push the format string pointer (1st arg) onto the stack
    call _printf                    ; Call the printf function
    add esp, 8                      ; Clean up the stack (2 arguments * 4 bytes = 8)

    ; --- Exit routine ---
    xor eax, eax                    ; Set return value to 0 (success exit code)
    ret                             ; Return control to the C runtime