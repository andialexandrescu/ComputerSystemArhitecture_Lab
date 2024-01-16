;# De mentionat ca acest program nu poate fi rulat, din moment ce nu exista procedura produsScalar
;# Procedura produsScalar primeste ca argumente, in ordine, adresa a doua tablouri unidimensionale de elemente de tip .long,
;# si returneaza produsul scalar al acestora; produsScalar(&v, &w, n)
;# Sa se scrie o procedura mutualOrtogonali care primeste ca argumente, in ordine, trei tablouri unidimensionale de elemente de tip .long, dimensiunea comuna, tot ca argument de tip .long, si returneaza in %eax valoarea 1 daca cei trei vectori descrisi de cele trei tablouri unidimensionale sunt mutual ortogonali, respectiv 0 in sens contrar
;# Doi vectori sunt ortogonali (sau perpendiculari) daca produsul lor scalar este 0
;# formula LaTeX: \( \vec{x} \ \vec{y} = |\vec{x}| \cdot |\vec{}| \cdot \cos(\theta) \)
;# https://www.math.uaic.ro/~bucataru/fizica/prod_scalar.pdf
.data
n: .long 7
u: .long 1, 0, 0, 1, 0, 0, 1, 0
v: .long 0, 1, 0, 0, 1, 0, 0, 1
w: .long 0, 0, 1, 0, 0, 1, 0, 0
;# u, v si w sunt ortogonali (https://ro.wikipedia.org/wiki/Ortogonalitate#:~:text=cazul%20secven%C8%9Bei%20ortonormale.-,Exemple,5%2F3)%20%3D%200.)
.text
;# rationament: pentru a determina daca trei vectori sunt ortogonali, trebuie verificat daca produsul scalar al oricaror doi vectori consecutivi este zero => daca rezultatul e diferit de zero, atunci vectorii nu sunt ortogonali, se trece la eticheta not_ortogonal
mutualOrtogonali:;# 8(%ebp) = $u, 12(%ebp) = $v, 16(%ebp) = $w, 18(%ebp) = n (n e lungimea comuna a vectorilor)
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    
    apelare_produsScalar:
    pushl 18(%ebp)
    pushl 8(%ebp)
    pushl 12(%ebp)
    call produsScalar
    addl $12, %esp
    ;# presupunem ca produsul scalar e returnat prin eax
    movl %eax, %ebx ;# in ebx e prod scalar dintre u si v
    cmpl $0, %ebx
    jne not_ortogonal
    
    pushl 18(%ebp)
    pushl 12(%ebp)
    pushl 16(%ebp)
    call produsScalar
    addl $12, %esp
    
    movl %eax, %ecx ;# in ecx e prod scalar dintre v si w
    cmpl $0, %ecx
    jne not_ortogonal
    
    pushl %ecx ;# salvare reg caller-saved
    pushl 18(%ebp)
    pushl 12(%ebp)
    pushl 16(%ebp)
    call produsScalar
    addl $12, %esp
    popl %ecx ;# restaurare reg caller-saved
    
    movl %eax, %edx ;# in edx e prod scalar dintre u si w
    cmpl $0, %edx
    jne not_ortogonal
    
    ortogonal:
    movl $1, %eax
    jmp forced_exit
    
    not_ortogonal:
    movl $0, %eax
    
    forced_exit:
    popl %ebx
    popl %ebp
    ret
.global main
main:
;# adancime maxima notOrtogonali ESP (liniile 42-50):
;# n
;# $w
;# $v
;# $u
;# adr_retur_main
;# %ebp
;# %ebx
;# %ecx
;# n
;# $v
;# $w
;# adr_retur_mutualOrtogonali
;# [...]