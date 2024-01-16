.data
n: .long 5
m: .long 100
formatPrintf: .asciz "%d "
.text
f:
    pushl %ebp
    movl %esp, %ebp
    
    movl 8(%ebp), %ecx ;# reordonare corecta de forma - source, destination
    movl 12(%ebp), %eax
    xorl %edx, %edx ;# initializare edx
    divl %ecx
    pushl %eax ;# corect: reg caller-saved eax e salvat sa nu fie distrus de printf
    
    f_for:
    pushl %ecx
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ecx ;# restaurare ecx caller-saved
    
    ;# trebuie evitata afisarea buffer-ului la pasul curent deoarece nu va tine cont de celelalte valori din loop si va afisa doar valoarea maximala, din moment ce prima valoare este n - 1
    ;#pushl $0
    ;#call fflush
    ;#popl %ebx
    
    ;# daca se pastreaza fflush se va afisa 4 25, insa faptul ca este implementat un for loop imi da de inteles ca output-ul dorit este 4 3 2 1 25
    
    loop f_for
    
    f_exit:
    popl %eax
    popl %ebp
    ret
.global main
main:
    movl n, %edx
    decl %edx
    
    pushl m
    pushl %edx
    call f
    popl %ebx
    popl %ebx
    
    pushl %eax
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx
    
    pushl $0
    call fflush
    popl %ebx
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80