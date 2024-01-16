;# f(x) = 
;# {
;#    stop, x = 1
;#    f(x/2), x par
;#    f(3*x+1), x impar
;# }

.data
x: .space 4
count: .long 0

formatPrintf: .asciz "%d\n"
formatScanf: .asciz "%d"

.text
f:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx ;# salvare reg callee-saved
    
    movl 8(%ebp), %eax ;# eax = x
    ;# base case
    cmp $1, %eax
    je f_exit
    
    pushl %eax ;# salvare eax
    
    movl $2, %ebx
    xorl %edx, %edx
    divl %ebx
    
    popl %eax ;# restaurare eax
    
    cmp $0, %edx ;# testare paritate; in edx se afla restul
    je f_even
    
    f_odd:
    incl count
    movl $3, %ebx
    mull %ebx;# ebx e tot 2
    incl %eax ;# eax = 3 * x + 1
    
    pushl %eax ;# parametru proc f + 
    ;# salvare si restituire pt construirea sol
    call f
    popl %eax
    
    jmp f_exit
    
    f_even:
    divl %ebx
    incl count
    
    pushl %eax
    call f
    popl %eax
    
    f_exit:
    popl %ebx ;# restaurare reg callee-saved
    popl %ebp
    ret

.global main
main:
    pushl $x
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    pushl x
    call f
    addl $4, %esp
    
afis_count:
    pushl count
    pushl $formatPrintf
    call printf
    addl $8, %esp
    
et_exit:    
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80