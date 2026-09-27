.global _start
.extern main

_start:
    xor %rbp, %rbp
    call main
    mov %eax, %edi
    mov $1, %rax
    syscall
