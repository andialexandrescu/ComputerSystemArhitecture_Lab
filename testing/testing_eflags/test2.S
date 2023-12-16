.data
    textSF: .asciz "SF activat\n"
    text2: .asciz "nu s-a activat\n"
.text
.global main
main:
SFtesting:
    movl $5, %eax
    movl $7, %ebx
    cmp %ebx, %eax
    js sign_label
    jmp et
SFtesting2:
    movw $0xfff2, %ax
    test %ax, %ax
    js sign_label
    jmp et
sign_label:
    mov $4, %eax
    mov $1, %ebx
    mov $textSF, %ecx
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