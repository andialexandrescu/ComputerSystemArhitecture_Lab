.data
    v: .byte 0, 1, 0, 0, 0, 1, 1, 0
    vIndex: .space 4
    n: .long 8
    formatPrintf: .asciz "%ld\n"
.text
.global main
main:
    ;# rezultatul concatenarii va fi in ebx
    movl $0, %ebx

    lea v, %edi
    movl $0, vIndex
for_concatenare:
    movl vIndex, %ecx
    cmp %ecx, n
    je afis_concatenare

    shl $1, %eax
    movzx (%edi, %ecx, 1), %edx
    or %edx, %eax
    
    ;#NU MERGE GRESIT
    

    incl vIndex
    jmp for_concatenare
afis_concatenare:
    pusha
    pushl %edx
    pushl $formatPrintf
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp
    
et_exit:
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
