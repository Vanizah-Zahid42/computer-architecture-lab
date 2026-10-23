section .bss
    N equ 256                       ; 256x256 matrix
    matrix resd N * N               ; Reserve contiguous memory (256 * 256 * 4 = 262,144 bytes)

section .data
    fmt db "Matrix Traversal Complete! Row-Major Sum: %d, Col-Major Sum: %d", 10, 0

section .text
    global _main                    ; Windows MinGW entry point
    extern _printf                  ; Import printf to show output

_main:
    ; =======================================================
    ; 1. Row-Major Sweep (Cache Friendly)
    ; =======================================================
    mov ecx, N                      ; Outer loop (rows)
    mov esi, matrix                 ; Base address
    xor eax, eax                    ; Accumulator for Row-Major sum

row_major_outer:
    push ecx                        ; Save outer loop counter
    mov ecx, N                      ; Inner loop (columns)
row_major_inner:
    add eax, dword [esi]            ; Read element and add to sum
    add esi, 4                      ; Sequential stride (4 bytes to next adjacent element)
    loop row_major_inner
    pop ecx                         ; Restore outer loop counter
    loop row_major_outer

    mov ebx, eax                    ; Save the Row-Major sum into EBX to print later

    ; =======================================================
    ; 2. Column-Major Sweep (Cache Hostile)
    ; =======================================================
    mov ecx, N                      ; Outer loop (columns)
    xor edi, edi                    ; Column offset tracker (0, 4, 8... 1020)
    xor eax, eax                    ; Accumulator for Col-Major sum

col_major_outer:
    push ecx                        ; Save outer loop counter
    mov ecx, N                      ; Inner loop (rows)
    mov esi, matrix                 ; Reset ESI to base address of matrix
    add esi, edi                    ; Apply the current column offset
col_major_inner:
    add eax, dword [esi]            ; Read element and add to sum
    add esi, N * 4                  ; Stride by entire row width (256 * 4 = 1024 bytes)
    loop col_major_inner
    
    add edi, 4                      ; Move offset to the next column
    pop ecx                         ; Restore outer loop counter
    loop col_major_outer

    ; =======================================================
    ; Print the results to verify it worked
    ; =======================================================
    push eax                        ; Push 3rd argument (Col-major sum from EAX)
    push ebx                        ; Push 2nd argument (Row-major sum from EBX)
    push fmt                        ; Push 1st argument (Format string)
    call _printf
    add esp, 12                     ; Clean up the stack (3 arguments * 4 bytes = 12)

    ; --- Windows Exit Routine ---
    xor eax, eax                    ; Return 0 (success)
    ret                             ; Return control to Windows C runtime