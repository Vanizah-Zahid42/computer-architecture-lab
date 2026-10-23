section .bss
    ARRAY_SIZE equ 2000000              ; Allocate roughly 2MB to support 1000 long strides
    memory_array resb ARRAY_SIZE

section .data
    fmt db "Power-of-2 Stride Cycles: %u", 10, "Offset Stride (1028) Cycles: %u", 10, 0

section .text
    global _main                        ; Windows MinGW entry point
    extern _printf

_main:
    ; =======================================================
    ; 1. Power-of-Two Stride (S = 1024 bytes)
    ; =======================================================
    mov esi, memory_array               ; Base address
    mov ecx, 1000                       ; 1000 iterations

    cpuid                               ; Serialize CPU pipeline
    rdtsc                               ; Read Time-Stamp Counter
    mov ebx, eax                        ; Save start time (lower 32-bits)

pow2_loop:
    mov edx, dword [esi]                ; Memory load
    add esi, 1024                       ; Stride by EXACTLY 1024 bytes (2^10)
    loop pow2_loop

    cpuid
    rdtsc
    sub eax, ebx                        ; EAX = Total cycles for Power-of-2 stride
    mov edi, eax                        ; Save these cycles into EDI

    ; =======================================================
    ; 2. Offset Stride (S = 1024 + 4 = 1028 bytes)
    ; =======================================================
    mov esi, memory_array               ; Reset base address
    mov ecx, 1000                       ; 1000 iterations

    cpuid                               ; Serialize CPU pipeline
    rdtsc
    mov ebx, eax                        ; Save start time

odd_loop:
    mov edx, dword [esi]                ; Memory load
    add esi, 1028                       ; Stride by 1028 bytes (breaks power-of-2 alignment)
    loop odd_loop

    cpuid
    rdtsc
    sub eax, ebx                        ; EAX = Total cycles for Offset stride

    ; =======================================================
    ; Print the results
    ; =======================================================
    push eax                            ; 3rd arg: Offset stride cycles
    push edi                            ; 2nd arg: Power-of-2 cycles
    push fmt                            ; 1st arg: Format string
    call _printf
    add esp, 12                         ; Clean stack

    ; --- Windows Exit Routine ---
    xor eax, eax                        ; Return 0
    ret