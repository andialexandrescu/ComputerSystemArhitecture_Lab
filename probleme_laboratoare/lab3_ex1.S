//facut la ora
//for(int i=n-1, i>=0, i--) s+=v[i];
.data
    v: .long 2,2,2,2
    n: .long 4
    s: .long 0
.text
.global main
main:
    mov n, %ecx
    dec %ecx
    mov $v, %esi
etbegin:
    cmp $0, %ecx
    jl etexit
    // v[i*4]
    mov (%esi, %ecx, 4), %eax
    add %eax, s
    dec %ecx
    jmp etbegin

etexit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80