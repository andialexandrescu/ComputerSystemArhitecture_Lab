;# int add(int *x, int y) => return sum;
;# printf("Suma celor %ld elemente este %ld\n.", n, add(v,n));
.data
    v: .long 1,2,3,4
    n: .long 4
    fs: .asciz "Suma celor %ld elemente este %ld\n."
.text
add:
    push %ebp
    mov %esp, %ebp
    push %esi ;# reg callee-saved

    ;# zona declarare var locale (nu avem)

    mov 8(%ebp), %esi ;# adrs de inceput a vectorului
    mov 12(%ebp), %eax ;# val lui n
    mov $0, %ecx ;# counter
    mov $0, %edx ;# suma

begin:
    cmp %eax, %ecx
    jge et
    add (%esi, %ecx, 4), %edx ;# calc suma in edx
    inc %ecx
    jmp begin

et:
    mov %edx, %eax ;# returnare prin eax
    ;# restituire var locale (nu avem)
    pop %esi ;# restituire a reg callee-saved
    pop %ebp
    ret
    
.global main
main:
    mov n, %ecx
    
    push %ecx ;# reg caller-saved
    
    pushl %ecx
    pushl $v
    call add
    add $8, %esp
    
    pop %ecx ;# reg caller-saved

    push %eax
    push %ecx
    pushl $fs
    call printf
    add $12, %esp
    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80