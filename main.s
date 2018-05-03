.intel_syntax noprefix

invalid_arg_msg:
    .asciz "Invalid amount of args!\n"

invalid_args:
    mov     edi, OFFSET invalid_arg_msg
    call puts
    jmp end

.globl main
main:
    xor     eax, eax
    mov     edx, 2
    cmp     edx, edi
    jne     invalid_args

end:
    ret
