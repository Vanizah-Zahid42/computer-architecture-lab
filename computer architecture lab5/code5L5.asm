section .bss
    N equ 16                        ; Matrix dimension (16x16)
    T equ 4                         ; Tile dimension (4x4 sub-blocks)
    matrixA resd N * N              ; Source matrix
    matrixB resd N * N              ; Destination matrix (Transposed)

section .data
    ii dd 0                         ; Outer block row
    jj dd 0                         ; Outer block col
    i  dd 0                         ; Inner tile row
    j  dd 0                         ; Inner tile col
    
    fmt db "Tiled Matrix Transposition Complete!", 10, 0

section .text
    global _main                    ; Windows MinGW entry point
    extern _printf

_main:
    ; === 1st Loop: Block Row (ii from 0 to N step T) ===
    mov dword [ii], 0
outer_ii:
    cmp dword [ii], N
    jge done

    ; === 2nd Loop: Block Col (jj from 0 to N step T) ===
    mov dword [jj], 0
inner_jj:
    cmp dword [jj], N
    jge next_ii

    ; === 3rd Loop: Inner Row (i from ii to ii+T-1) ===
    mov eax, dword [ii]
    mov dword [i], eax              ; i = ii
loop_i:
    mov eax, dword [ii]
    add eax, T
    cmp dword [i], eax              ; if (i >= ii + T) jump
    jge next_jj

    ; === 4th Loop: Inner Col (j from jj to jj+T-1) ===
    mov eax, dword [jj]
    mov dword [j], eax              ; j = jj
loop_j:
    mov eax, dword [jj]
    add eax, T
    cmp dword [j], eax              ; if (j >= jj + T) jump
    jge next_i

    ; === Body: B[j][i] = A[i][j] ===
    
    ; Calculate offset for A[i][j] = (i * N + j) * 4 bytes
    mov eax, dword [i]
    imul eax, N
    add eax, dword [j]
    shl eax, 2                      ; Multiply by 4 (size of dword)
    mov esi, matrixA
    add esi, eax                    ; ESI points to A[i][j]
    mov edx, dword [esi]            ; LOAD element from A

    ; Calculate offset for B[j][i] = (j * N + i) * 4 bytes
    mov eax, dword [j]
    imul eax, N
    add eax, dword [i]
    shl eax, 2
    mov edi, matrixB
    add edi, eax                    ; EDI points to B[j][i]
    mov dword [edi], edx            ; STORE element into B

    ; Increment j and repeat 4th loop
    inc dword [j]
    jmp loop_j

    ; Increments for the outer loops
next_i:
    inc dword [i]
    jmp loop_i

next_jj:
    add dword [jj], T
    jmp inner_jj

next_ii:
    add dword [ii], T
    jmp outer_ii

done:
    ; --- Print the result to verify it worked ---
    push fmt
    call _printf
    add esp, 4                      ; Clean up 1 argument

    ; --- Windows Exit Routine ---
    xor eax, eax                    
    ret