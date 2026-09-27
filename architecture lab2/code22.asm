global _main
extern _printf

section .data
formatRaw db "Raw EFLAGS = 0x%08X", 10, 0
formatFlags db "Zero Flag (ZF) = %d, Carry Flag (CF) = %d", 10, 0

section .text
_main:

    ; Step 1: Perform an operation that sets ZF = 1 and CF = 0
    mov eax, 5
    sub eax, 5             ; 5 - 5 = 0

    ; Step 2: Push EFLAGS register onto the stack
    pushfd

    ; Step 3: Pop the flags value into EBX to inspect it
    pop ebx

    ; Display the raw 32-bit flags register
    push ebx
    push formatRaw
    call _printf
    add esp, 8

    ; Step 4: Extract the Zero Flag (Bit 6)
    ; Copy EBX to ECX and shift bit 6 into bit position 0
    mov ecx, ebx
    shr ecx, 6
    and ecx, 1             ; ECX now contains only 0 or 1

    ; Step 5: Extract the Carry Flag (Bit 0)
    ; Copy EBX to EDX and isolate bit 0
    mov edx, ebx
    and edx, 1             ; EDX now contains only Bit 0

    ; Step 6: Print the individual flag values
    push edx               ; CF
    push ecx               ; ZF
    push formatFlags
    call _printf
    add esp, 12

    ; Return 0 to Windows
    xor eax, eax
    ret