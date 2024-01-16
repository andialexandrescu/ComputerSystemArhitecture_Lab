;# aduna(long a, long b) 
;# {
;#     return a+b;
;# }
;# iteratie(long *a, long *b) 
;# {
;#     long c;
;#     c=aduna(*a, *b);
;#     (*a)=(*b); (*b)=c;
;# }
;# int main()
;# {
;#     long n=5, x=1, y=1, z;
;#     register long i;
;#     for(i=2;i<n;++i) iteratie(&x,&y);
;#     z=y;
;# }
;# Fibonacci iterativ
.data
n: .space 4
z: .space 4

x: .long 1
y: .long 1
formatScanf: .asciz "%ld"
formatPrintf: .asciz "%ld\n"
.text
aduna: ;# 8(%ebp) = a, 12(%ebp) = b, return in %eax
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %ecx ;# ecx = a
    movl 12(%ebp), %edx ;# edx = b

    movl 0(%ecx), %eax
    addl 0(%edx), %eax ;# eax = a + b; rezultat aduna(a, b)
    pop %ebp
    ret

iteratie: ;# 8(%ebp)= a, 12(%ebp)=b, -4(%ebp) = c
    push %ebp
    movl %esp, %ebp

    subl $4, %esp ;# variabila locala c de tip long
    
    movl 12(%ebp), %eax ;# eax = &y
    movl 8(%ebp), %ecx ;# ecx = &x
    
    ;# aduna(*a, *b) ; {x} {y}
    pushl %eax ;# &b
    pushl %ecx ;# &a
    call aduna
    addl $8, %esp
    
    
    movl %eax, -4(%ebp) ;# c = aduna(*a, *b)
    ;# (*a)=(*b)
    movl 8(%ebp), %eax 
    movl 12(%ebp), %ecx
    movl 0(%ecx), %edx
    movl %edx, 0(%eax)
    ;# (*b)=c
    movl -4(%ebp), %eax 
    movl %eax, 0(%ecx)

    addl $4, %esp ;# scoaterea de pe stiva a lui c
    pop %ebp
    ret
.global main
main:
    pushl $n
    pushl $formatScanf
    call scanf
    addl $8, %esp

    movl $2, %ecx
for_fibonacci:
    cmp %ecx, n
    je exit_for_fibonacci
    
    push %ecx ;# salvare reg caller-saved, 
    ;# fiind un contor a carei valoare trebuie retinuta

    pushl $y
    pushl $x
    call iteratie
    addl $8, %esp

    pop %ecx ;# restaurare reg caller-saved
    incl %ecx
    jmp for_fibonacci
exit_for_fibonacci:
    movl y, %eax
    movl %eax, z ;# z = y
    
    pushl z
    push $formatPrintf
    call printf
    addl $8, %esp
    
exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80