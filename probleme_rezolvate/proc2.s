;# Sa se implementeze un program care sa calculeze functia f(x) = 2g(x), unde g(x) = x + 1.
.data
x: .space 4

formatScanf: .asciz "%ld"
formatPrintf: .asciz "%ld\n"
.text
g: ;# 8(%ebp) = y ;# g(x) = x + 1
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
    addl $1, %eax

    popl %ebp
    ret

f: ;# 8(%ebp) = x ; f(x) = 2g(x)
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %eax ;# eax = x
    ;# reg caller-saved
    pushl %eax ;# transmitere parametru proc g; 
    ;# fara salvare + restaurare eax
    call g ;# rezultatul va fi in eax
    addl $4, %esp ;# eax = x + 1

    xorl %edx, %edx
    movl $2, %ebx
    mull %ebx ;# eax = 2 * (x + 1)

    popl %ebp
    ret

.global main
main:
    pushl $x
    pushl $formatScanf
    call scanf
    addl $8, %esp

    pushl x
    call f ;# rez in eax
    addl $4, %esp

    pushl %eax
    pushl $formatPrintf
    call printf
    addl $8, %esp

    push $0
    call fflush
    addl $4, %esp
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80 