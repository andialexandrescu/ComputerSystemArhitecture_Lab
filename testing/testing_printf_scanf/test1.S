.data
    x: .space 4 
    formatstr_citire: .asciz "%ld"
    formatstr_afisare: .asciz "Numarul citit si acum afisat este: %ld"
.text
.global main
main:
afisare:
    pushl x
    pushl $formatstr_afisare
    call printf
    popl %ebx
    popl %ebx
    
    pushl $0
    call fflush
    popl %ebx
citire:
    pushl $x
    pushl $formatstr_citire
    call scanf
    popl %ebx
    popl %ebx

etexit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
    