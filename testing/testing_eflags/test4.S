.data
    textPF: .asciz "PF activat\n"
    text2: .asciz "nu s-a activat\n"
.text
.global main
main:
PFtesting:
    movl $0x2, %eax
    test $1, %eax
    jp parity_label
    jmp et
parity_label:
    mov $4, %eax
    mov $1, %ebx
    mov $textPF, %ecx
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