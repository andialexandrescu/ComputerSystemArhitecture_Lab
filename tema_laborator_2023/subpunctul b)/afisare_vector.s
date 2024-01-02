.data 
    v: .long 0, 1, 0, 0, 0, 1
    vIndex: .space 4
    n: .long 6
    formatPrintf: .asciz "%ld"
.text
.global main
main:
lea v, %edi
movl $0, vIndex
afis_numar_in_binar:
    movl vIndex, %ecx
    cmp %ecx, n
    je et_exit
    
    movl (%edi, %ecx, 4), %eax
    
    pusha
    pushl %eax
    pushl $formatPrintf
    call printf
    addl $8, %esp
    popa

    push $0
    call fflush
    addl $4, %esp
    
    incl vIndex
    jmp afis_numar_in_binar
et_exit:

    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
