;# De mentionat ca acest program nu poate fi rulat, din moment ce nu exista procedura reciprocInverse
.data
.text
perecheInversabila:;# 8(%ebp) = $m1, 12(%ebp) = $m2, 16(%ebp) = $m3, 18(%ebp) = n (n e dimensiunea comuna a matricelor)
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    
    apelare_reciprocInverse:
    pushl 18(%ebp)
    pushl 8(%ebp)
    pushl 12(%ebp)
    call reciprocInverse
    addl $12, %esp
    ;# se continua a se verifica toate combinatiile posibile, in speranta ca se gaseste cel putin o pereche de matrice mutual inverse
    movl %eax, %ebx ;# in ebx e raspunsul la intrebarea daca m1 si m2 sunt mutual inverse
    cmpl $0, %ebx
    jne inversabile_12
    
    pushl 18(%ebp)
    pushl 12(%ebp)
    pushl 16(%ebp)
    call reciprocInverse
    addl $12, %esp
    
    movl %eax, %ecx ;# in ecx e raspunsul la intrebarea daca m2 si m3 sunt mutual inverse
    cmpl $0, %ecx
    jne inversabile_23
    
    pushl %ecx ;# salvare reg caller-saved
    pushl 18(%ebp)
    pushl 12(%ebp)
    pushl 16(%ebp)
    call reciprocInverse
    addl $12, %esp
    popl %ecx ;# restaurare reg caller-saved
    
    movl %eax, %edx ;# in edx e raspunsul la intrebarea daca m1 si m3 sunt mutual inverse
    cmpl $0, %edx
    jne inversabile_13
    
    not_inversabile:
    movl $-1, %eax
    movl $-1, %ecx
    jmp forced_exit
    
    inversabile_12:
    lea $8(%ebp), %eax
    lea $12(%ebp), %ecx
    jmp forced_exit
    
    inversabile_23:
    lea $12(%ebp), %eax
    lea $16(%ebp), %ecx
    jmp forced_exit
    
    inversabile_13:
    lea $8(%ebp), %eax
    lea $16(%ebp), %ecx
    
    forced_exit:
    popl %ebx
    popl %ebp
    ret
.global main
main:
;# adancime maxima mutualProportionali ESP (liniile 29-37):
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
;# adr_retur_mutualProportionali
;# [...]