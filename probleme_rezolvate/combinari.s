;#Se introduc de la tastatura n si k (k ≤ n). Sa se scrie o functie C(n, k) recursiva ce calculeaza
;#combinari de n luate cate k dupa formula: C(0, 0) = C(n, n) = 1, C(n, k) = C(n − 1, k) +
;#C(n − 1, k − 1).
.data
n: .space 4
k: .space 4

formatScanf: .asciz "%ld"
formatPrintf: .asciz "Combinari de %ld luate cate %ld sunt %ld\n" ;# {n} {k} {%eax = rezolvarea}

.text
combinari: 
    ;# 8(%ebp) = n, 12(%ebp) = k
    ;# cand k == 0 return 1
    ;# cand k == n return 1
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx ;# salvare reg calee-saved
    movl 8(%ebp), %ecx ;# ecx = n
    movl 12(%ebp), %edx ;# edx = k

    cmp %ecx, %edx ;# cand k == n return 1
    jne verif

    movl $1, %eax ;# in eax e rezultatul combinarilor
    jmp exit_combinari

verif:
    cmp $0, %edx ;# cand k == 0 return 1
    jne continue

    movl $1, %eax
    jmp exit_combinari
continue: ;# C(n, k) = C(n − 1, k) + C(n − 1, k − 1).
    ;# folosesc %ebx pentru adunarea celor 2 valori
    ;# folosesc %ecx = n, %edx = k
    ;# folosesc %eax pentru returnare

    ;# C(n − 1, k)
    decl %ecx ;# n = n - 1
    pushl %edx
    pushl %ecx
    call combinari
    pop %ecx
    pop %edx

    movl %eax, %ebx
    decl %edx ;# k = k - 1
    
    ;# C(n − 1, k − 1)
    ;# ac secv de cod implica atat furnizarea parametrilor functiei care 
    ;# trebuie pusi pe stiva, cat si o salvare si restaurare a reg caller-saved
    pushl %edx
    pushl %ecx
    call combinari
    pop %ecx
    pop %edx

    addl %eax, %ebx ;# C(n − 1, k) + C(n − 1, k − 1)

    movl %ebx, %eax
exit_combinari:
    pop %ebx ;# restaurare reg callee-saved
    pop %ebp
    ret
.global main
main:
    ;#citesc n
    pushl $n
    pushl $formatScanf
    call scanf
    addl $8, %esp
    
    ;# citesc k
    pushl $k
    pushl $formatScanf
    call scanf
    addl $8, %esp

    xorl %ebx, %ebx
    
    pushl k
    pushl n
    call combinari ;# return %eax
    addl $8, %esp

    pushl %eax
    pushl k
    pushl n
    pushl $formatPrintf
    call printf
    addl $16, %esp

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80