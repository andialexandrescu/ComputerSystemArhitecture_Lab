.data
x: .space 4
y: .space 4
formatScanf: .asciz "%ld"
formatPrintf: .asciz "%ld"
.text
customEven:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx ;# callee-saved
    subl $4, %esp ;# var locala
    
    ;# base case
    movl 12(%ebp), %eax
    movl 8(%ebp), %ebx
    mull %ebx
    
    cmpl $0, %eax
    jle forced_exit
    
    movl $0, -4(%ebp)
    for_customEven:
        cmpl $0, %eax
        je verif_paritate
        
        xorl %edx, %edx
        movl $10, %ebx
        divl %ebx
        addl %edx, -4(%ebp)
        
        jmp for_customEven
    
    verif_paritate:
    movl -4(%ebp), %eax
    andl $1, %eax
    
    forced_exit:
    addl $4, %esp
    popl %ebx
    popl %ebp
    ret
.global main
main:
    pushl $x
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    pushl $y
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    pushl x
    pushl y
    call customEven
    addl $8, %esp
    
    pushl %eax
    pushl $formatPrintf
    call printf
    addl $8, %esp
    
    pushl $0
    call fflush
    addl $4, %esp
    
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80