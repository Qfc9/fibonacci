.intel_syntax noprefix

invalid_arg_msg:
    .asciz "Invalid amount of args!\n"

invalid_value_msg:
    .asciz "Invalid value!\n"

asdf:
    .asciz "%x answer\n"

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
    mov     rdx, 101
    cmp     rdx, rax
    jle     invalid_argv

    # Checking if argv[0] > 0
    mov     rdx, 0
    cmp     rdx, rax
    jge     invalid_argv

    # Counter
    mov     rcx, -1
    # First
    xor     rsi, rsi
    # Second
    xor     rdx, 1
    # Result
    xor     rdi, rdi

    mov     r8, 1

1:
    inc     rcx
    cmp     rcx, r8
    jle     1b

    xadd    rdx, rsi

    cmp     rcx, rax
    jne     1b


    # mov     rdi, OFFSET asdf
    # mov     rsi, rdx
    # cld

    push    rbx
    # lea     rdi, [rip]
    mov     rdi, OFFSET asdf
    mov     rsi, rdx
    xor     rax, rax

    call    printf

    pop rbx

end:
    ret
