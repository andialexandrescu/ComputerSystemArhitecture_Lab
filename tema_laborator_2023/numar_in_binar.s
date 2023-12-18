.data
    binIndex: .space 4
    bin: .space 32 ;# 8 * 4
    n: .space 4
    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld"

.text
.global main
main:
    pushl $n
    pushl $formatScanf
    call scanf
    add $8, %esp

lea bin, %edi
movl n, %eax
movl $7, %ecx
movl $2, %ebx
numar_in_binar:
    cmp $0, %eax
    je init_afis_numar_in_binar

    movl $0, %edx
    divl %ebx ;# mereu va fi impartit (edx, eax) la 2, de aceea edx trebuie reinitializat la fiecare pas
    
    ;# in edx se afla restul, iar in eax catul impartirii la ebx (= 2)
    movl %edx, (%edi, %ecx, 4) ;# deoarece counter-ul e parcurs descrescator, adica restul impartirii lui eax la 2 va fi concatenat de la stanga la dreapta (daca counter-ul era parcurs in mod obisnuit, ar fi fost nevoie de o inversiune ulterior a sirului generat)
    
    subl $1, %ecx
    jmp numar_in_binar
    
init_afis_numar_in_binar: 
    lea bin, %edi
    movl $0, binIndex
afis_numar_in_binar:
    movl binIndex, %ecx
    cmp $8, %ecx
    je et_exit
    
    movl (%edi, %ecx, 4), %eax
    
    pusha
    pushl %eax
    pushl $formatPrintf
    call printf
    addl $8, %esp
    popa

    push $0
    call fflush
    addl $4, %esp
    
    incl binIndex
    jmp afis_numar_in_binar

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
