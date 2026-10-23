section .bss
    ; To support 1000 iterations at a max stride of 128 bytes, 
    ; we need an array of at least 128,000 bytes.
    ARRAY_SIZE equ 128000
    array resb ARRAY_SIZE           ; Reserve uninitialized bytes

section .data
    STRIDE equ 64                   ; CHANGE THIS: Test with 4, 16, 32, 64, 128
    ITERATIONS equ 1000             ; Equivalent total load count
    
    fmt db "Successfully traversed with stride %d for %d iterations.", 10, 0 

section .text
    global _main                    ; Windows MinGW entry point
    extern _printf                  ; Import printf to show output

_main:
    mov ecx, ITERATIONS             ; Set loop counter to 1000
    mov esi, array                  ; Base address of the array
    xor eax, eax                    ; Clear EAX (Accumulator to simulate work)

stride_loop:
    mov edx, dword [esi]            ; LOAD: Fetch data at the current address
    add eax, edx                    ; Dummy operation to process the data
    
    add esi, STRIDE                 ; STRIDE: Advance pointer by S bytes
    loop stride_loop                ; Decrement ECX and repeat

    ; --- Print the result to verify it worked ---
    push ITERATIONS                 ; Push 3rd argument (1000)
    push STRIDE                     ; Push 2nd argument (Current Stride)
    push fmt                        ; Push 1st argument (Format string)
    call _printf                    ; Call C standard library printf
    add esp, 12                     ; Clean up the stack (3 arguments * 4 bytes = 12)

    ; --- Windows Exit Routine ---
    xor eax, eax                    ; Return 0 (success)
    ret                             ; Return control to Windows C runtime