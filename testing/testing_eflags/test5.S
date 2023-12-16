.data
    textCF: .asciz "CF activat\n"
    text2: .asciz "nu s-a activat\n"
.text
.global main
main:
CFtesting:
    movl $0xfffffffe, %eax
    add $3, %eax
    jc carry_label
    jmp et
carry_label:
    mov $4, %eax
    mov $1, %ebx
    mov $textCF, %ecx
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