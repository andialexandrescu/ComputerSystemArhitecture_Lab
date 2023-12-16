
//for(int i=n-1, i>=0, i--) s+=v[i];
.data
    v: .long 2,2,2,2
    n: .long 4
    s: .long 0
.text
.global main
main:
// v[(n-1)*4], v[ecx]
// v[(n-2)*4], ecx=ecx-4, v[ecx]

    lea v, %edi
    mov n, %ecx
    dec %ecx
    shl $2, %ecx // ecx = (n-1) * 4
    add %ecx, %edi // edi = $v + (n-1) * 4; $v + (n-2) * 4....$v + 1*4, $v
etbegin:
    cmp $v, %edi
    jl etexit

    mov 0(%edi), %eax
    add %eax, s
    sub $4, %edi
    jmp etbegin
etexit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80