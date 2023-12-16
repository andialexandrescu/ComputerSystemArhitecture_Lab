;# Sa se implementeze o procedura care calculeaza recursiv factorialul unui numar
;# int factorial(int n)
;#{
;#    if(n<=1)
;#        return 1;
;#    else
;#        return n * factorial(n-1);
;#}

.data
    n: .long 4
    fs: .asciz "%ld! = %ld\n"
.text
factorial:
    push %ebp
    mov %esp, %ebp
    push %ebx ;# callee-saved

    mov 8(%ebp), %eax
    mov $1, %ebx
    cmp %ebx, %eax ;# if (n<=1) jmp eticheta_stop
    jle stop

    mov %eax, %ecx
    dec %ecx ;# ecx = n-1

    push %eax ;# salvarea reg caller-saved eax
    push %ecx
    call factorial
    ;# returnare in eax din factorial
    mov %eax, %ecx
    add $4, %esp
    pop %eax ;# restaurarea reg caller-saved eax
    ;# eax = n, ecx = factorial(n-1)

    mul %ecx ;# eax = eax * ecx = n * factorial(n-1)
    ;# return ...

    jmp final

stop:
    mov $1, %eax ;# return 1;

final:
    pop %ebx
    pop %ebp
    ret

.global main
main:
    push n
    call factorial
    add $4, %esp
    ;# eax = factorial(n)

    ;# %ld! = %ld
    push %eax
    push n
    push $fs
    call printf
    add $12, %esp ;# sau 3 pop-uri

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80