global _main
extern _printf

section .data
format1 db "AH = 0x%02X, AL = 0x%02X -> AX = 0x%04X", 10, 0
format2 db "Full EAX after packing = 0x%08X", 10, 0

section .text
_main:

    ; Step 1: Start with a completely clean 32-bit register
    xor eax, eax

    ; Step 2: Load values into the 8-bit sub-registers
    mov ah, 0x12
    mov al, 0x34

    ; Step 3: Read the combined 16-bit AX register
    ; Zero-extend AX into ECX for printf
    movzx ecx, ax

    ; Zero-extend AH and AL for printf
    movzx edx, ah
    movzx ebx, al

    ; Step 4: Push arguments from right to left
    push ecx            ; Value of AX
    push ebx            ; Value of AL
    push edx            ; Value of AH
    push format1
    call _printf
    add esp, 16         ; Clean up 4 pushed items

    ; Step 5: Shift AX into the upper half of EAX
    ; Shifting left by 16 bits moves AX to bits 16-31
    shl eax, 16

    ; Load new values into the lower bytes
    mov ah, 0x56
    mov al, 0x78

    ; Step 6: Print full 32-bit EAX register
    push eax
    push format2
    call _printf
    add esp, 8

    ; Return 0 to Windows
    xor eax, eax
    ret