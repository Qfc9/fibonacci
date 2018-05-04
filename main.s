.intel_syntax noprefix

invalid_arg_msg:
    .asciz "Invalid amount of args!\n"

invalid_value_msg:
    .asciz "Invalid value!\n"

asdf:
    .asciz "%d\n"

invalid_argc:
    mov     edi, OFFSET invalid_arg_msg
    call puts
    jmp end

invalid_argv:
    mov     edi, OFFSET invalid_value_msg
    call puts
    jmp end

.globl main
main:
    # Checks argc == 2
    xor     eax, eax
    mov     edx, 2
    cmp     edx, edi
    jne     invalid_argc

    # Making argv[0] into a number
    mov     rdi, [rsi + 8]
    mov     rsi, 0
    mov     rdx, 10    
    call    strtol

    # Checking if argv[0] <= 100
    mov     rdx, 100
    cmp     rdx, rax
    jl      invalid_argv

    # Checking if argv[0] > 0
    xor     rdx, rdx
    cmp     rdx, rax
    jg      invalid_argv

    # If the value is 0
    cmp     rax, rdx
    je      2f

    # Counter
    mov     rcx, 0
    # First
    xor     rsi, rsi
    # Second
    mov     rdx, 1

    # Counter Check
    mov     r8, 1

    # Fib Loop
1:
    cmp     rcx, rax
    je      2f

    inc     rcx

    cmp     rcx, r8
    je      1b

    xadd    rdx, rsi

    jmp     1b

2:
    # Printf result
    push    rbx
    mov     rdi, OFFSET asdf
    mov     rsi, rdx
    xor     rax, rax

    call    printf

    pop rbx

end:
    ret
