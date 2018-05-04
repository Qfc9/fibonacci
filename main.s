.intel_syntax noprefix

.data
invalid_arg_msg:
    .asciz "Invalid amount of args!\n"

invalid_value_msg:
    .asciz "Invalid value!\n"

hex_format:
    .asciz "%llx"

result1:
    .quad 0

result2:
    .quad 0

hex_output1:
    .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

hex_output2:
    .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

result_output:
    .asciz "%s%s\n"


.text

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

    xor     rdi, rdi

    # If the value is 0
    cmp     rax, rdx
    je      2f

    # Counter
    mov     rcx, 0
    # First
    xor     rsi, rsi
    # Second
    mov     r10, 1
    xor     rdx, rdx

    # Fib Loop
1:
    cmp     rcx, rax
    je      2f

    inc     rcx

    cmp     rcx, 1
    je      1b

    xadd    r10, rsi
    adc     rdx, 0
    xadd    rdi, rdx

    jmp     1b

2:

    mov     QWORD PTR [result1], r10
    mov     QWORD PTR [result2], rdi

    cmp     rdi, 0
    je      3f     

    push    rbx
    mov     rdi, OFFSET hex_output1
    mov     rsi, 32
    mov     rcx, [result2]
    mov     rdx, OFFSET hex_format
    call    snprintf

    pop rbx

3:
    push    rbx
    mov     rdi, OFFSET hex_output2
    mov     rsi, 32
    mov     rcx, [result1]
    mov     rdx, OFFSET hex_format
    call    snprintf

    pop rbx

    # Printf result
    push    rbx
    mov     rdi, OFFSET result_output
    mov     rsi, OFFSET hex_output1
    mov     rdx, OFFSET hex_output2
    xor     rax, rax

    call    printf

    pop rbx

end:
    ret
