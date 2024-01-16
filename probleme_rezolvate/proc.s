;#void proc(long x) 
;# {
;#     printf("\%ld ", x);
;#     if (x != 0)
;#         proc(x-1);
;# }

.data
x: .space 4

formatScanf: .asciz "%ld"
formatPrintf: .asciz "\%ld "
.text
proc: ;# 8(%ebp) = x
    pushl %ebp
    movl %esp, %ebp
    ;# nu e nevoie de restaurarea niciunui registru callee-saved, 
    ;# oricum nu sunt prezenti in aceasta procedura
    
    ;# printf("\%ld ", x);
    pushl 8(%ebp)
    pushl $formatPrintf
    call printf
    addl $8, %esp

    movl 8(%ebp), %ecx ;# ecx = x
    cmp $0, %ecx
    je exit_proc ;# if(x==0) jmp exit_proc
    
    ;# fiind un subprogram care nu necesita o memorie interna, 
    ;# nu salvam si restauram reg caller-saved inainte de apelarea recursiva
    decl %ecx ;# x = x - 1
    push %ecx ;# proc(x - 1)
    call proc
    addl $4, %esp
    
    exit_proc:
    pop %ebp
    ret
.global main
main:
    pushl $x
    push $formatScanf
    call scanf
    addl $8, %esp

    pushl x
    call proc
    addl $4, %esp

    pushl $0
    call fflush
    pop %ebx
    
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80