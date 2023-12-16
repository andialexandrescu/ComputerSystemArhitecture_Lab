;# Sa se implementeze un program care calculeaza functia g(x) = f(x) + f(x+1), unde f(x) = x + 4. Sa se afiseze pe ecran valoarea pentru f(5) + 3g(1) ( = 42)
;# f(x) = x + 4
;# g(x) = f(x) + f(x+1)
.data
    fs: .asciz "f(5) + 3g(1) = %ld\n"
.text
f:
    push %ebp
    mov %esp, %ebp

    mov 8(%ebp), %eax
    add $4, %eax

    ;#eax = return value
    pop %ebp
    ret
g:
;# ne-ar ajuta sa restauram val initiala stocata in eax, adica y, pt a face y+1, ce e asociata expresiei g(y) = f(y) + f(y+1)
    push %ebp
    mov %esp, %ebp
    push %ebx

    mov 8(%ebp), %eax
    push %eax ;# salvare reg caller-saved
    push %eax ;# argumentul functiei f -> f(y)
    call f
    ;# eax = val returnata de f = f(%eax) = f(1)
    mov %eax, %ebx ;# ebx = f(1)
    add $4, %esp
    pop %eax ;# restaurare reg caller-saved

    ;# eax = y, ebx = f(y)

    ;# ebx = reg callee-saved
    add $1, %eax
    push %eax
    call f
    add $4, %esp;# il scoatem pe eax de pe stiva

    ;# eax = f(y+1), ebx = f(y)

    add %ebx, %eax
    ;# eax = f(y) + f(y+1)

    pop %ebx
    pop %ebp
    ret
.global main
main:
    ;# f(5) + 3g(1)
    push $5
    call f
    add $4, %esp ;# eliberam stiva pt un long (in loc de pop %edx sau alt registru - garbage collector)
    ;#eax = f(5) = 5 + 4 = 9
    mov %eax, %ebx ;#ebx = f(5)

    push $1
    call g
    add $4, %esp
    ;# eax = g(1), ebx = f(5)

    mov $3, %ecx
    mul %ecx ;# eax = eax * ecx = g(1) * 3

    add %ebx, %eax ;# eax = f(5) + 3g(1)

    push %eax
    push $fs
    call printf
    add $8, %esp;# ac var nu implica un reg suplimentar, in loc de doua pop-uri

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80