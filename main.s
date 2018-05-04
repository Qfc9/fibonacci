.intel_syntax noprefix

.data
invalid_arg_msg:
    .asciz "Invalid amount of args!\n"

invalid_value_msg:
    .asciz "Invalid value!\n"

invalid_flag_msg:
    .asciz "Invalid flag!\n"

hex_format:
    .asciz "%llx"

oct_format:
    .asciz "%llo"

oct_flag:
    .quad 0

lower_bin:
    .quad 0

higher_bin:
    .quad 0

lower:
    .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

higher:
    .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

result_output:
    .asciz "%s%s\n"

.text

invalid_argc:
    mov     edi, OFFSET invalid_arg_msg
    call    puts
    jmp     end

invalid_argv:
    mov     edi, OFFSET invalid_value_msg
    call    puts
    jmp     end

invalid_flag:
    mov     edi, OFFSET invalid_flag_msg
    call    puts
    jmp     end

shift:
    add     rdi, 1
    jmp     main_loop

.globl main
.globl jump_here
main:
    # Checks argc == 2
    xor     eax, eax
    mov     edx, 2
    cmp     edx, edi
    je      3f

    # Checks argc == 3
    mov     edx, 3
    cmp     edx, edi
    je      4f

    jmp invalid_argc

4:
    # Making argv[0] into a number
    mov     rax, [rsi + 8]
    mov     rax, [rax]
    and     rax, 0x000000000000FFFF
    cmp     rax, 28461
    jne     invalid_flag

    # Making argv[1] into a number
    mov     rdi, [rsi + 8*2]
    mov     rsi, 0
    mov     rdx, 10    
    call    strtol
    mov     QWORD PTR [oct_flag], 1
    mov     QWORD PTR [oct_flag], 1
    jmp     the_cmp

3:
    # Making argv[0] into a number
    mov     rdi, [rsi + 8]
    mov     rsi, 0
    mov     rdx, 10    
    call    strtol

the_cmp:
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
    mov     r8, 1
    xor     rdx, rdx


    mov     r11, 0x7FFFFFFFFFFFFFFF

    # Fib Loop
1:
main_loop:
    cmp     rcx, rax
    je      2f

    inc     rcx

    cmp     rcx, 1
    je      1b

    xadd    r8, rsi
    adc     rdx, 0
    xadd    rdi, rdx

    cmp     QWORD PTR [oct_flag], 1
    je      oct_carry

    jmp     1b

oct_carry:
    mov     r12, r8
    and     r8, r11
    cmp     r8, r12
    jne     shift
    jmp     1b


2:
    mov     QWORD PTR [lower_bin], r8
    mov     QWORD PTR [higher_bin], rdi     

   # higher = 0
    cmp     rdi, 0
    je      print_next

    mov     rcx, [higher_bin]
    mov     rdi, OFFSET higher
    jmp     bin_to_hex1

print_next:
    mov     rcx, [lower_bin]
    mov     rdi, OFFSET lower
    jmp     bin_to_hex2

results:
    jmp     display_results

end:
    ret


bin_to_hex1:
    push    rbx
    mov     rsi, 32
    
    cmp     QWORD PTR [oct_flag], 1
    jne     1f

    mov     rdx, OFFSET oct_format
    jmp     2f

1:
    mov     rdx, OFFSET hex_format

2:
    call    snprintf

    pop     rbx
    jmp     print_next

bin_to_hex2:
    push    rbx
    mov     rsi, 32

    cmp     QWORD PTR [oct_flag], 1
    jne     1f

    mov     rdx, OFFSET oct_format
    jmp     2f

1:
    mov     rdx, OFFSET hex_format

2:
    call    snprintf

    pop     rbx
    jmp     results

display_results:
    # Printf result
    push    rbx
    mov     rdi, OFFSET result_output
    mov     rsi, OFFSET higher
    mov     rdx, OFFSET lower

    call    printf
    pop rbx
    xor     rax, rax
    jmp end

