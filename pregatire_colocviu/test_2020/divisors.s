.data
x: .space 4
formatScanf: .asciz "%ld"
formatPrintf: .asciz "%ld\n"
.text
divisors:
    pushl %ebp
    movl %esp, %ebp
    
    movl $1, %ecx
    for_divisors:
        movl 8(%ebp), %eax
        cmpl %eax, %ecx
        jg forced_exit
        
        xorl %edx, %edx
        divl %ecx
        cmpl $0, %edx
        jne cont_for_divisors
        
        pushl %ecx ;# salvare ecx + parametru printf
        pushl $formatPrintf
        call printf
        addl $4, %esp
        popl %ecx ;# restaurare ecx
        
        cont_for_divisors:
        incl %ecx
        jmp for_divisors
   
    forced_exit:
    popl %ebp
    ret
.global main
main:
    pushl $x
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    pushl x
    call divisors
    addl $4, %esp
    
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80