.data
    x: .long 12
    y: .long 8
    si_test: .space 4
.text
.global main
main:
    mov x, %eax
    test y, %eax
    mov %eax, si_test
et_exit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80