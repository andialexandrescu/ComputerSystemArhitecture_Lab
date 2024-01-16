;#Sa se citeasca n iar apoi n numare. Sa se faca o procedura de forma:
;# aduna($s, n, x1, x2, x3, ... , xn), iar in s sa se afle suma numerelor x1, x2, x3, ... , xn

;# problema pentru push-uri mobile
.data
n: .space 4
a: .space 4
s: .space 4
vector: .space 400

formatScanf: .asciz "%ld"
formatPrintf: .asciz "%ld\n"

.text
aduna: ;# 8(%ebp) = $s; 12(%ebp) = n; 16(%esp), 20(%esp), ... <-> x1, x2, ...
    pushl %ebp
    movl %esp, %ebp

    ;# nu e nevoie sa initializam suma
    movl 8(%ebp), %eax ;# valoarea s va fi modificata in cadrul acestei functii
    
    movl $0, %ecx ;# setam un contor la 0
    for_aduna:
        cmp 12(%ebp), %ecx ;# if(ecx == n) jmp exit_for_aduna
        je exit_for_aduna

        movl 16(%ebp, %ecx, 4), %edx ;# luam valoarea de la adresa (%ebp + 4 * contor + 16)
        ;# offset = 16, deoarece incepand cu 16 se afla valorile din vector in stiva
        addl %edx, 0(%eax) ;# adunam la suma

        incl %ecx
        jmp for_aduna
    exit_for_aduna:
    pop %ebp
    ret
.global main
main:
;# citim n
pushl $n
pushl $formatScanf
call scanf
addl $8, %esp

;#creare vector
xorl %ecx, %ecx
lea vector, %edi
for_i:
    cmp %ecx, n
    je exit_for_i

    pusha
    pushl $a
    pushl $formatScanf
    call scanf
    add $8, %esp
    popa

    movl a, %eax
    movl %eax, (%edi, %ecx, 4)

    incl %ecx
    jmp for_i
exit_for_i:
;# incepe sa punem pe stiva fiecare elem din vector
movl n, %ecx
subl $1, %ecx ;# ultimul element din vector are indicele n-1 -> xn-1
for_push:
    cmpl $0, %ecx
    jl cont_date
    
    movl (%edi, %ecx, 4), %eax
    pushl %eax

    decl %ecx
    jmp for_push
cont_date:
pushl n
push $s
call aduna

;#calculam cate popuri trb sa facem 4 + 4 + 4 * n = 4(n+2)
movl n, %eax
addl $2, %eax
movl $4, %edx
mull %edx

addl %eax, %esp

pushl s
pushl $formatPrintf
call printf
addl $8, %esp

exit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80