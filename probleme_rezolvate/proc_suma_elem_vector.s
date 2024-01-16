.data
v: .space 20 ;# 5 elem de tip long => 5*4
i: .space 4
n: .long 5
x: .space 4
suma: .space 4

formatScanf: .asciz "%d"
formatPrintf: .asciz "%d \n"

.text
proc:
    pushl %ebp
    movl %esp, %ebp
    
    ;# 16(%ebp) = adresa vector
    ;# 12(%ebp) = adresa suma
    ;# 8(%ebp) = n
    
    movl 12(%ebp), %eax
    movl 16(%ebp), %esi
    
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    et_aduna:;# suma elementelor vectorului
        cmpl 8(%ebp), %ebx
        je et_final

        movl (%esi, %ebx, 4), %edx
        addl %edx, %ecx

        incl %ebx
        jmp et_aduna

    et_final:
        movl %ecx, 0(%eax);# valoarea sumei se afla in ecx
        
        popl %ebp
        ret

.global main
main:
    movl $0, suma
    movl $0, i
    movl n, %eax

    lea v, %esi
et_citire: ;# se citesc 5 elemente ale vectorului v de la tastatura
    movl i, %ecx
    cmp n, %ecx
    je et_func

    pusha
    pushl $x
    pushl $formatScanf
    call scanf
    addl $8, %esp
    popa
    
    movl x, %edx
    movl %edx, (%esi, %ecx, 4)

    incl i
    jmp et_citire
    
et_func:
    pushl $v
    pushl $suma
    pushl n
    call proc ;# proc(n, &v, &suma)
    addl $12, %esp
    
afisare_suma:
    pushl suma
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