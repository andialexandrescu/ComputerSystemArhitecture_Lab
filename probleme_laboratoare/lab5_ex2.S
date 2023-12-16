;# reg callee-saved - daca se intampla ca procedura sa fol in corpul propriu are si obligatia sa-i salveze (o restaurare la final) - fie nu foloseste registrul (nu face parte din procedura), fie il salveaza
;# reg caller-saved - se face o restaurare manuala (se salveaza val din registru inainte de procedura pe stiva esp, adica in main) daca se doreste ca modificarea reg in urma apelului functiei sa fie vazuta si inafara procedurii, adica in main, iar ulterior cand e scoasa de pe stiva sa fie restaurata la val initiala de catre program
.data
    x: .long 2
    y: .long 3
    s: .space 4
    fs: .asciz "%ld\n"
.text
add_sub2:
    push %ebp;
    mov %esp, %ebp
    ;#reg callee-saved - salvez aici %ebx, inainte de argumente, se salveaza pe stiva
    push %ebx

    movl 8(%ebp), %eax  ;# x
    addl 12(%ebp), %eax  ;# y
    movl 16(%ebp), %ebx
    movl %eax, 0(%ebx)

    sub $4, %esp
    mov 8(%ebp), %eax ;# x
    sub 12(%ebp), %eax ;# y
    mov %eax, -8(%ebp) ;# t e la -8 (din cauza instruct push ebx)
    
    mov -8(%ebp), %eax ;# valoarea de retur (e ultima modificare adusa asupra lui eax)

    add $4, %esp
    pop %ebx ;# scot reg callee-saved de pe stiva
    pop %ebp
    ret

.global main
main:
    mov $1, %ebx
    mov $2, %eax

    pushl %eax ;# reg caller-saved
    pushl $s
    pushl y
    pushl x
    call add_sub2
    ;# ebx = 1, eax = return value
    mov %eax, %ecx
    popl %edx
    popl %edx
    popl %edx
    popl %eax;# in eax avem val initiala salvata (2) inainte de procedura
    ;# eax = 2 (caller-saved), ecx = return value
    
    ;# printf("%ld", add(x,y,&s));
    pushl %ecx ;# in ecx se afla val de retur a procedurii
    pushl $fs
    call printf
    popl %eax
    popl %eax
    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
    