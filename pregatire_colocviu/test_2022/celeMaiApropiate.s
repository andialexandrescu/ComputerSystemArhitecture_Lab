;# De mentionat ca acest program nu poate fi rulat, din moment ce nu exista procedura distantaCuvinte
;# Procedura distantaCuvinte primeste ca argumente, in ordine, adresa a doua siruri de caractere
;# si returneaza o distanta, numita distanta Levenshtein; distantaCuvinte(&cuv1, &cuv2)
;# Sa se scrie o procedura celeMaiApropiate care primeste ca argumente, in ordine, trei siruri de caractere si returneaza in %eax si %ecx adresa sirurilor intre care distanta Levenshtein este cea mai mica
.data
sir1: .asciz "stergere"
sir2: .asciz "inserare"
sir3: .asciz "crestere"
;# https://www.cnic.ro/bioinfo/exemple_js/ccLevenshteinDist.htm
;# distantaCuvinte(&sir1, &sir2) = 5
;# distantaCuvinte(&sir2, &sir3) = 6
;# distantaCuvinte(&sir1, &sir3) = 4
.text
celeMaiApropiate:;# 8(%ebp) = $sir1, 12(%ebp) = $sir2, 16(%ebp) = $sir3; in main sunt introduse pe stiva in ordinea {sir3} -> {sir2} -> {sir1}
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx ;# salvare reg callee-saved
    subl $4, %esp;# o var locala care va stoca minimul
    
    selectare_mai_mic_12_13:
    pushl 8(%ebp)
    pushl 12(%ebp)
    call distantaCuvinte
    addl $8, %esp
    
    movl %eax, %ebx ;# in ebx e distanta dintre sir1 si sir2
     
    pushl 12(%ebp)
    pushl 16(%ebp)
    call distantaCuvinte
    addl $8, %esp
    
    movl %eax, %ecx ;# in ecx e distanta dintre sir2 si sir3
    
    pushl %ecx ;# salvare reg caller-saved
    pushl 8(%ebp)
    pushl 16(%ebp)
    call distantaCuvinte
    addl $8, %esp
    popl %ecx ;# restaurare
    
    movl %eax, %edx;# in edx e distanta dintre sir1 si sir3
    
    comparare_12_23:
    cmpl %ebx, %ecx
    jl seteaza_min_23
    
    seteaza_min_12:
    ;# d12 < d23
    movl %ebx, -4(%ebp)
    jmp comparare_min_curent_13
    
    seteaza_min_23:
    ;# d23 < d12
    movl %ecx, -4(%ebp)
    
    comparare_min_curent_13:
    cmpl -4(%ebp), %edx
    jl seteaza_min_13
    ;# minimul ramane acelasi
    jmp retur_adrese_siruri
    
    seteaza_min_13:
    ;# min_d12_d23 < d13
    movl %edx, -4(%ebp)
    
    retur_adrese_siruri:
    cmpl -4(%ebp), %ebx ;# daca min e d12
    je seteaza_adr_12
    
    cmpl -4(%ebp), %ecx ;# daca min e d23
    je seteaza_adr_23
    
    cmpl -4(%ebp), %edx ;# daca min e d13
    je seteaza_adr_13
    
    seteaza_adr_12:
    lea $8(%ebp), %eax
    lea $12(%ebp), %ecx
    jmp forced_exit
    
    seteaza_adr_23:
    lea $12(%ebp), %eax
    lea $16(%ebp), %ecx
    jmp forced_exit
    
    seteaza_adr_13:
    lea $8(%ebp), %eax
    lea $16(%ebp), %ecx
    jmp forced_exit
    
    forced_exit:
    addl $4, %esp
    popl  %ebx ;# restaurare reg callee-saved
    popl %ebp
    ret
.global main
main:
;# pushl $sir3
;# pushl $sir2
;# pushl $sir1
;# ...
;# nu se va face salvarea + restaurarea reg caller-saved eax si ecx, din moment ce se doreste ca rezultatele sa fie returnate, adica sa fie vizibile la nivel de main

;# intre liniile 34 si 41 se regaseste adancimea maxima a stivei ESP:
;# $sir3
;# $sir2
;# $sir1
;# adr_retur_main
;# %ebp
;# %ebx
;# spatiu_var_locala
;# %ecx
;# $sir1
;# $sir3
;# adr_retur_celeMaiApropiate
;# [...] depinde cum se comporta procedura distantaCuvinte
    