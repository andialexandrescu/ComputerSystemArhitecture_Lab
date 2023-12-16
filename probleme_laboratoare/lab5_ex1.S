;# vrem sa implementam:
;# int add(x, y, &s)
#{
#    s=x+y;
#    long t;
#    t=x-y;
#    return t;
#}
;# trebuie sa aloc spatiu pentru toate variabilele locale din procedura pt a le pune pe stiva
;# spatiu de un long pe stiva: sub $4, %esp (se muta %esp 4 locatii mai jos), atunci cand nu vrem sa avem o valoare efectiva pe stiva, evitam fol pushl
;# stiva exista intre %ebp (baza stivei - sus) si %esp (vf stivei - jos) 
.data
    x: .long 2
    y: .long 3
    s: .space 4
    t: .space 4
.text
;#VAR1
add_sub:
    movl 4(%esp), %eax ;# accesare x
    addl 8(%esp), %eax ;# accesare y
    movl 12(%esp), %ebx
    movl %eax, 0(%ebx)

    sub $4, %esp;# locatia pt t=x-y
    mov 8(%esp), %eax ;# x
    sub 12(%esp), %eax ;# y
    mov %eax, 0(%esp);# depozitam val diferentei in t pt ca in vf stivei acum se afla t
    ;# in %eax avem x-y

    ;#maniera in care realizam scaderea: obs ca x este apelat altfel decat pt suma, e redundant, ar trebui sa fol %ebp
    add $4, %esp;# scoatem t din stiva
    ret;# scoatem adresa de intoarcere in main
    ;# intotdeauna pt a modifica variabile deja existente in .data, mutam adresa variabilei in %esp, fara adrese ar fi exprimate strict valoric

;#VAR2 - %ebp e baza stivei, dar ar fi intotdeauna baza cadrului de apel/ procedurii noi apelate, acum %ebp e pozitionat jos
;# daca salvam %ebp pe stiva la inceputul functiei, putem reapela val ant, realizandu-se o revenire la baza cadrului de apel anterior, asemenea unui chain
add_sub2:
    push %ebp
    mov %esp, %ebp
    ;# luam val din stiva %esp si o depozitam in %ebp (pastram leg intre cadrurile de apel - vrem sa avem capacitatea de a reveni)
    ;# de data acesta argumentele vor fi raportate la un cadru static
    ;# acum totul se raporteaza la %ebp

    movl 8(%ebp), %eax 
    addl 12(%ebp), %eax 
    movl 16(%ebp), %ebx
    movl %eax, 0(%ebx)

    sub $4, %esp
    mov 8(%ebp), %eax 
    sub 12(%ebp), %eax
    mov %eax, -4(%ebp)

    add $4, %esp
    pop %ebp
    ret

.global main
main:
    pushl $s
    pushl y
    pushl x
    call add_sub;# add_sub2
    popl %edx
    popl %edx
    popl %edx
    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80