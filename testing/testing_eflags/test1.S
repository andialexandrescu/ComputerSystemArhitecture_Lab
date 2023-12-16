.data
    textZF: .asciz "ZF activat\n"
    text2: .asciz "nu s-a activat\n"
.text
.global main
main:
ZFtesting:
    movl $7, %eax
    movl $7, %ebx
    cmp %ebx, %eax
    jz zero_label
    jmp et
ZFtesting2:
    movl $0, %eax
    test %eax, %eax
    jz zero_label
    jmp et
zero_label:
    mov $4, %eax
    mov $1, %ebx
    mov $textZF, %ecx
    mov $12, %edx
    int $0x80
et:
    mov $4, %eax
    mov $1, %ebx
    mov $text2, %ecx
    mov $15, %edx
    int $0x80
    jmp exit
exit:
    mov $1, %eax
    mov $0, %ebx
    int $0x80