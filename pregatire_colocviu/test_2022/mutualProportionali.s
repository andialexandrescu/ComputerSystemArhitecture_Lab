;# De mentionat ca acest program nu poate fi rulat, din moment ce nu exista procedura factorProportionalitate
;# Factorul de proportionalitate intre doi vectori este un scalar care, atunci cand inmultit cu primul vector, produce al 
;# doilea vector. Mai precis, daca avem doi vectori u si v si exista un scalar k a.i. k*u=v, atunci u si v sunt
;# proportionali si scalarul k este factorul de proportionalitate
.data
.text
;# rationament: pentru a determina daca trei vectori sunt proportionali, intr-o succesiune de vectori proportionali, raportul intre oricare doi vectori consecutivi trebuie sa fie acelasi, adica factorii de proportionalitate intre toate perechile consecutive de vectori sunt egali si diferiti de zero (altfel factorul nu e intreg) => daca rezultatul cel putin al unui factor de proportionalitate e zero, atunci se trece la eticheta not_proportional, dupa ce se testeaza faptul ca fiecare factor e intreg (sunt date valide pt a fi comparate), se verifica daca sunt egali doi cate doi, daca nu sunt se trece la not_proportionali
mutualProportionali:;# 8(%ebp) = $u, 12(%ebp) = $v, 16(%ebp) = $w, 18(%ebp) = n (n e lungimea comuna a vectorilor)
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    
    apelare_factorProportionalitate:
    pushl 18(%ebp)
    pushl 8(%ebp)
    pushl 12(%ebp)
    call factorProportionalitate
    addl $12, %esp
    
    movl %eax, %ebx ;# in ebx e factorul proportional dintre u si v
    cmpl $0, %ebx
    je not_proportionali
    
    pushl 18(%ebp)
    pushl 12(%ebp)
    pushl 16(%ebp)
    call factorProportionalitate
    addl $12, %esp
    
    movl %eax, %ecx ;# in ecx e factorul proportional dintre v si w
    cmpl $0, %ecx
    je not_proportionali
    
    testare_factori_k1_k2:
    cmpl %ebx, %ecx
    jne not_proportionali
    
    pushl %ecx ;# salvare reg caller-saved
    pushl 18(%ebp)
    pushl 12(%ebp)
    pushl 16(%ebp)
    call factorProportionalitate
    addl $12, %esp
    popl %ecx ;# restaurare reg caller-saved
    
    movl %eax, %edx ;# in edx e factorul proportional dintre u si w
    cmpl $0, %edx
    je not_proportionali
    
    testare_factori_k2_k3:
    cmpl %ecx, %edx
    jne not_proportionali
    
    proportionali:
    movl $1, %eax
    jmp forced_exit
    
    not_proportionali:
    movl $0, %eax
    
    forced_exit:
    popl %ebx
    popl %ebp
    ret
.global main
main:
;# adancime maxima mutualProportionali ESP (liniile 42-50):
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