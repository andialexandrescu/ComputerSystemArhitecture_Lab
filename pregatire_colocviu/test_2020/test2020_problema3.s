.data
n: .long 5
v: .long 21, 56, 78, 2, 3
formatPrintf: .asciz "%ld\n"
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
    jle forced1_exit
    
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
    
    forced1_exit:
    addl $4, %esp
    popl %ebx
    popl %ebp
    ret
divisors:
    pushl %ebp
    movl %esp, %ebp
    
    movl $1, %ecx
    for_divisors:
        movl 8(%ebp), %eax
        cmpl %eax, %ecx
        jg forced2_exit
        
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
   
    forced2_exit:
    popl %ebp
    ret
.global main
main:
    subl $1, n
    lea v, %edi
    xorl %ecx, %ecx
    for_elem:
        cmpl n, %ecx ;# n - 1 != ecx
        jne caz_general
        
        caz_particular:
        ;# v[n-1], v[0]
        movl (%edi, %ecx, 4), %ebx ;# ebx = v[n-1]
        pushl %ecx
        movl $0, %ecx
        movl (%edi, %ecx, 4), %edx ;# edx = v[0]
        popl %ecx
        
        pushl %ecx ;# salvare + restaurare reg caller-saved
        pushl %ebx
        pushl %edx
        call customEven
        addl $8, %esp
        popl %ecx
        
        cmpl $1, %eax
        jne cont_caz_particular
        
        movl (%edi, %ecx, 4), %ebx
        pushl %ecx
        pushl %ebx
        call divisors
        addl $4, %esp
        popl %ecx
        
        cont_caz_particular:
        jmp et_exit
        
        caz_general:
        movl (%edi, %ecx, 4), %ebx ;# ebx = v[i]
        incl %ecx
        movl (%edi, %ecx, 4), %edx ;# edx = v[i+1]
        decl %ecx
        
        pushl %ecx ;# salvare + restaurare reg caller-saved
        pushl %ebx
        pushl %edx
        call customEven
        addl $8, %esp
        popl %ecx
        
        cmpl $1, %eax
        jne cont_for_elem
        
        movl (%edi, %ecx, 4), %ebx
        pushl %ecx
        pushl %ebx
        call divisors
        addl $4, %esp
        popl %ecx
        
        cont_for_elem:
        incl %ecx
        jmp for_elem
   
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80