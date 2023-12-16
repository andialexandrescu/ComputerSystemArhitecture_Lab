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

    movl n, %ecx
    subl $1, %ecx
etloop: ;# for(ecx=n-1, ecx>=1, ecx--)
    cmp $1, %ecx ;# in mom in care ecx devine 1, nu dorim continuarea verificarii divizibilitatii
    jz prim
    
    movl n, %eax
    xorl %edx, %edx ;# init edx=0, echival movl $0, %edx
    divl %ecx ;# (edx,eax)=(edx,eax)/ecx 
    cmp $0, %edx 
    je nu_e_prim 
    ;# daca restul e egal de 0, nr are un divizor, adica nu e prim
    
    loop etloop
    ;# in mod normal aici ar fi existat un jmp prim, insa e definit mai sus, deoarece orice nr e divizibil cu 1

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