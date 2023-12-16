.data
    x: .byte 0b01101011
    y: .byte 0b10011101
    a: .long 0xffff1234
.text
.global main
main:
    mov x, %ah
    shl $4, %ah

    mov y, %bl
    shr $4, %bl

    mov a, %ecx
    sal $4, %ecx

    mov a, %edx
    sar $4, %edx

    jmp et_exit
et_exit:
    mov $1, %eax
    mov $0, %ebx
    int $0X80
