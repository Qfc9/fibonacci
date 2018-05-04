.intel_syntax noprefix

.data
invalid_arg_msg:
    .asciz "Invalid amount of args!\n"

invalid_value_msg:
    .asciz "Invalid value!\n"

hex_format:
    .asciz "%llx"

oct_option:
    .asciz "o-"

oct_format:
    .asciz "%llo"

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
    call puts
    jmp end

invalid_argv:
    mov     edi, OFFSET invalid_value_msg
    call puts
    jmp end

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
    xor     eax, eax
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
    jne      end

    # Making argv[1] into a number
    mov     rdi, [rsi + 8*2]
    mov     rsi, 0
    mov     rdx, 10    
    call    strtol
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
    mov     r10, 1
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

    xadd    r10, rsi
    adc     rdx, 0
    xadd    rdi, rdx

    # mov     r12, r10
    # and     r10, r11
    # cmp     r10, r12
    # jne     shift

    jmp     1b

2:
    mov     QWORD PTR [lower_bin], r10
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
    mov     rdx, OFFSET hex_format
    call    snprintf

    pop     rbx
    jmp     print_next

bin_to_hex2:
    push    rbx
    mov     rsi, 32
    mov     rdx, OFFSET hex_format
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
