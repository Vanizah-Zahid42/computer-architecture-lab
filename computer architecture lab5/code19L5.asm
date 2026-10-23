section .bss
    ; Pre-allocated space to build the linked list
    pool resb 100000

section .data
    STRIDE equ 64
    fmt db "Pointer chasing complete for Stride %d.", 10, 0

section .text
    global _main
    extern _printf

_main:
    ; Setup: Create a linked list where each node points to the next node STRIDE bytes away
    mov ecx, 1000
    mov esi, pool
build_list:
    mov eax, esi
    add eax, STRIDE
    mov dword [esi], eax        ; Store pointer to next node
    mov esi, eax
    loop build_list

    ; Traversal: Chase the pointers
    mov ecx, 1000
    mov ebx, pool               ; Starting node

chase_loop:
    mov ebx, dword [ebx]        ; Dereference current pointer to get the next pointer
    loop chase_loop

    push STRIDE
    push fmt
    call _printf
    add esp, 8
    xor eax, eax
    ret