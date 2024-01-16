;# Scrieti un program care sa calculeze al n-lea termen (tn) din sirul lui Fibonacci (folosind
;#recursivitate). Afisati la final un text de forma Al n-lea element din sirul lui Fibonacci este x.
;#Vom considera primele 2 elemente t0 = 0 si t1 = 1. Exemplu: n = 5 => Al 5-lea termen din
;#sirul lui Fibonacci este 5. 
;# 0 1 1 2 3 5
;# F(n) = F(n-1) + F(n-2)

.data
n: .space 4

formatScanf: .asciz "%ld"
formatPrintf: .asciz "Al %ld-lea element din sirul lui Fibonacci este %ld\n" ;# {n} {x}
.text
fibonacci: ;# 8(%ebp) = n 
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx ;# salvare reg callee-saved

    movl 8(%ebp), %ecx ;# ecx = n

    cmp $0, %ecx
    jne verif2

    movl $0, %eax
    jmp exit_fibonacci
    
    verif2:
    cmp $1, %ecx
    jne continue

    movl $1, %eax
    jmp exit_fibonacci

    continue:
    
    decl %ecx ;# ecx = n - 1
    
    xorl %ebx, %ebx ;# ebx = 0

    pushl %ecx ;# salvare reg caller-saved + parametru functie
    call fibonacci
    popl %ecx ;# restaurare reg caller-saved

    decl %ecx ;# ecx = n - 2
    addl %eax, %ebx ;# ebx = fibonacci(n-1)

    pushl %ecx ;# salvare reg caller-saved
    call fibonacci
    pop %ecx ;# salvare reg caller-saved

    addl %eax, %ebx ;# ebx = fibonacci(n-1) + fibonacci(n-2)
    movl %ebx, %eax ;# eax = ebx = rezultatul
    
    exit_fibonacci:
    pop %ebx ;# restaurare reg caller-saved
    pop %ebp
    ret
.global main
main:
    pushl $n
    pushl $formatScanf
    call scanf
    addl $8, %esp

    movl n, %eax
fib:
    xorl %eax, %eax
    xorl %ebx, %ebx
    pushl n
    call fibonacci ;# rez in eax
    addl $4, %esp

afisarea:
    pushl %eax ;# val rezultatului
    pushl n
    pushl $formatPrintf
    call printf
    addl $12, %esp

exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80