.data
    textOF: .asciz "OF activat\n"
    text2: .asciz "nu s-a activat\n"
.text
.global main
main:
OFtesting:
    movw $0x7fff, %ax
    subw $-1, %ax
    jo overflow_label
    jmp et
OFtesting2:
    movl $0x7fffffff, %eax
    add $1, %eax
    jo overflow_label
    jmp et
overflow_label:
    mov $4, %eax
    mov $1, %ebx
    mov $textOF, %ecx
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