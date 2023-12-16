;# se citeste un nr n de la tastatura. sa se afiseze toti divizorii improprii ai lui n
.data
    n: .space 4
    input: .asciz "%ld"
    fs: .asciz "%ld\n"
.text
.global main
main:

citire:
    pushl $n
    pushl $input
    call scanf
    popl %ebx
    popl %ebx

    movl $2, %ecx
for: ;# for(ecx=2, ecx<n, ecx++)
    cmp n, %ecx
    je etexit

    movl n, %eax
    xorl %edx, %edx
    divl %ecx ;# (edx,eax)=(edx,eax)/ecx 
    cmp $0, %edx 
    je et_div
    ;# daca restul e egal de 0, nr are cel putin un divizor
    
    continue:
    incl %ecx
    jmp for
    
et_div:
    pusha
    pushl %ecx
    pushl $fs
    call printf
    popl %ebx
    popl %ebx
    popa
    
    jmp continue
    
etexit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80