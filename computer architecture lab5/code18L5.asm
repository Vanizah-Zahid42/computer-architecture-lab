section .data
    test_var dd 42                      ; Target memory address to benchmark
    fmt db "Cold Miss Latency: %u cycles", 10, "Hot Hit Latency:   %u cycles", 10, 0

section .text
    global _main                        ; Windows MinGW entry point
    extern _printf

_main:
    mov esi, test_var

    ; =======================================================
    ; 1. Measure Cold-Miss Latency (DRAM Fetch)
    ; =======================================================
    clflush [esi]                       ; Explicitly evict line from all cache levels
    
    cpuid                               ; Serialize CPU pipeline to prevent out-of-order execution
    rdtsc                               ; Read Time-Stamp Counter into EDX:EAX
    mov ebx, eax                        ; Save start time (lower 32-bits)

    mov edi, dword [esi]                ; MEMORY LOAD (Triggers DRAM cold-start miss)

    cpuid                               ; Serialize pipeline after load completes
    rdtsc                               ; Read Time-Stamp Counter again
    sub eax, ebx                        ; EAX = End Time - Start Time (Cycles)
    mov ecx, eax                        ; Save the Cold Miss cycle count into ECX

    ; =======================================================
    ; 2. Measure Hot-Hit Latency (L1 Cache)
    ; =======================================================
    cpuid                               ; Serialize
    rdtsc
    mov ebx, eax                        ; Save start time

    mov edi, dword [esi]                ; MEMORY LOAD (Triggers L1 cache hit)

    cpuid
    rdtsc
    sub eax, ebx                        ; EAX = Hot Hit cycle count

    ; =======================================================
    ; Print the results
    ; =======================================================
    push eax                            ; 2nd arg: Hot Hit cycles
    push ecx                            ; 1st arg: Cold Miss cycles
    push fmt                            
    call _printf
    add esp, 12                         

    ; --- Windows Exit Routine ---
    xor eax, eax                        
    ret