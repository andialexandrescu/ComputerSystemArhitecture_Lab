;# fie v un vector cu 100 de elem. se citesc de la tastatura un nr n si apoi n elem care se stocheaza in v. sa se realizeze o parcurgere a acestui vector si sa se afiseze toate nr divizibile cu 2.
;# de revazut - nu functioneaza
.data 
    n: .space 4
    fs: .asciz "%ld\n"
    v: .space 40
.text
.global main
main:
    ;#citire n tastatura
    pushl $n
    pushl $fs
    call scanf
    popl %ebx
    popl %ebx
    
    lea v, %edi ;# adr de inceput vector
    movl n, %ecx
citire_v:
    mov n, %eax
    sub %ecx, %eax ;# %eax=n-%ecx, index
    
    ;# citire n elem de la tastatura si memorarea lor in vectorul v
    pushl %edi
    pushl $fs
    call scanf
    popl %ebx 
    popl %ebx ;# in %edx se va afla v[%edi+%eax*4]
    add $4, %edi;# v[%edi+4] succesiv
    
    loop citire_v
    
    movl $0, %ecx
    subl $1, n ;# n va fi modificat, dar nu il mai folosim decat pt a ne asigura ca %ecx contorizeaza numai de la 0 la n-1 elem din vector
for_div_2:
    cmp n, %ecx
    je et_exit;# %ecx ajunge la n-1 conditie oprire
    
    movl (%edi,%ecx,4), %edx ;# pt usurinta
    test %edx, %edx ;# testam paritatea verificand daca LSB e 0, adica e nr par
    jnp continue 

et_div:;# afisam elem divizibile cu 2
    pusha
    pushl %edx ;# val din vector sunt in %edx
    pushl %fs
    call printf
    popl %ebx
    popl %ebx
    popa
    
    continue:
    incl %ecx
    jmp for_div_2
    
et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80