.intel_syntax noprefix

# Defining my variables
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

lower_str:
    .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

higher_str:
    .asciz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"

result_output:
    .asciz "%s%s\n"

.text

# Printing invalid argc
invalid_argc:
    mov     edi, OFFSET invalid_arg_msg
    call    puts
    jmp     end

# Printing invalid argv
invalid_argv:
    mov     edi, OFFSET invalid_value_msg
    call    puts
    jmp     end

# Printing invalid - flag
invalid_flag:
    mov     edi, OFFSET invalid_flag_msg
    call    puts
    jmp     end

# Octal math, adding 1 if the 64th bit is set
shift:
    add     rdi, 1
    jmp     main_fib_loop

.globl main
.globl jump_here
main:
    # Checks argc == 2
    xor     eax, eax
    mov     edx, 2
    cmp     edx, edi
    je      2f

    # Checks argc == 3
    mov     edx, 3
    cmp     edx, edi
    je      1f

    jmp invalid_argc

1:
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

2:
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

    # rdi is for the higher_bin
    xor     rdi, rdi

    # If the value is 0
    cmp     rax, rdx
    je      2f

    # Counter
    xor     rcx, rcx

    # rsi Temp variable for r8
    xor     rsi, rsi

    # r8 Stores the lower_bin
    mov     r8, 1

    # rdx Carry tracker and higher_temp
    xor     rdx, rdx

    # r9 Octal Mask for getting the 64th bit
    mov     r9, 0x7FFFFFFFFFFFFFFF

    # Fib Loop
main_fib_loop:
    # Is the loop done?
    cmp     rcx, rax
    je      2f

    # counter++
    inc     rcx

    # If the counter is 1
    cmp     rcx, 1
    je      main_fib_loop

    # Main Fib math with the carry to the higher
    xadd    r8, rsi
    adc     rdx, 0
    xadd    rdi, rdx

    # Do octal math if flag is set
    cmp     QWORD PTR [oct_flag], 1
    je      oct_carry

    jmp     main_fib_loop

    # For octal carry the 64th bit
oct_carry:
    mov     r10, r8
    and     r8, r9
    cmp     r8, r10
    jne     shift
    jmp     main_fib_loop

    # Breaking out of loop and storing higher and lower
2:
    mov     QWORD PTR [lower_bin], r8
    mov     QWORD PTR [higher_bin], rdi     

   # Skipping higher conversion
    cmp     rdi, 0
    je      convert_lower

    # Converting Higher Part
    push    rbx
    mov     rcx, [higher_bin]
    mov     rdi, OFFSET higher_str
    mov     rsi, 32

    # Is it octal?
    cmp     QWORD PTR [oct_flag], 1
    jne     1f
    mov     rdx, OFFSET oct_format
    jmp     2f
1:
    mov     rdx, OFFSET hex_format
2:
    call    snprintf
    pop     rbx

    # Converting Lower Part
convert_lower:
    push    rbx
    mov     rcx, [lower_bin]
    mov     rdi, OFFSET lower_str
    mov     rsi, 32

    # Is it octal?
    cmp     QWORD PTR [oct_flag], 1
    jne     1f
    mov     rdx, OFFSET oct_format
    jmp     2f
1:
    mov     rdx, OFFSET hex_format
2:
    call    snprintf
    pop     rbx

    # Printing final results
    push    rbx
    mov     rdi, OFFSET result_output
    mov     rsi, OFFSET higher_str
    mov     rdx, OFFSET lower_str

    call    printf
    pop     rbx
    xor     rax, rax

end:
    ret
