;# sa se verifice daca un numar citit de la tastatura este prim sau nu si sa se afiseze un mesaj
.data
    n: .space 4
    input: .asciz "%ld"
    formatstr_prim: .asciz "Numarul %ld este prim\n"
    formatstr_nu_e_prim: .asciz "Numarul %ld nu este prim\n"
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
etloop: ;# for(ecx=2, ecx<n, ecx++)
    cmp n, %ecx
    je prim #conditie iesire: daca nu iese din for inseamna ca e nr prim

    movl n, %eax
    xorl %edx, %edx ;# init edx=0, echival movl $0, %edx
    divl %ecx ;# (edx,eax)=(edx,eax)/ecx 
    cmpl $0, %edx 
    je nu_e_prim 
    ;# daca restul e egal de 0, nr are un divizor, adica nu e prim
    
    incl %ecx ;# increment(inc) long(l)
    jmp etloop

prim:
    pushl n
    pushl $formatstr_prim
    call printf
    popl %ebx
    popl %ebx
    jmp etexit

nu_e_prim:
    pushl n
    pushl $formatstr_nu_e_prim
    call printf
    popl %ebx
    popl %ebx
    jmp etexit

etexit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80