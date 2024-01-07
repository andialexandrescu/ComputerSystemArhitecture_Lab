.data
    key: .long 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1,0, 0, 1, 1, 1, 0, 0, 0 ,1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1 ,1, 1, 0, 0, 0, 1, 1 ,0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0
    binKey: .space 10
    bin: .space 4
    i: .space 4
    j: .space 4
    keyIndex: .space 4
    vIndex: .space 4
    messageLength: .long 10
    maxMessageLength: .long 80
    
    formatPrintfByte: .asciz "%ld "
.text
.global main
main:
compunere_binKey:
    movl $0, i 

    movl $0, keyIndex
for_keyIndex2:;# for(int keyIndex=0; keyIndex<messageLength; keyIndex++)
    movl keyIndex, %ecx
    cmp %ecx, messageLength
    je init_afis_binKey

    movl $0, bin 

    movl $0, j
    for_bit_conversie:;# for(int j=0; j<8; j++)
        movl j, %ecx
        cmpl $8, %ecx
        je stocheaza_byte
        
        movl i, %ecx
        cmpl %ecx, maxMessageLength
        jle stocheaza_byte

        ;# bin va reprezenta secventa formata din cate 8 biti stocati succesiv in key
        shlb $1, bin
        lea key, %esi
        movl (%esi, %ecx, 4), %eax ;# bit-ul de rang i
        orb %al, bin

        incl i

        incl j
        jmp for_bit_conversie

    stocheaza_byte:
        lea binKey, %edi
        movl keyIndex, %ecx
        movb bin, %dl
        movb %dl, (%edi, %ecx)
        ;# binKey[keyIndex] = bin
        
    incl keyIndex
    jmp for_keyIndex2

init_afis_binKey:
    movl $0, vIndex
afis_binKey:
    movl vIndex, %ecx
    cmp %ecx, messageLength
    je et_exit

    lea binKey, %edi
    movb (%edi, %ecx), %dl
    movb %dl, bin

    pusha
    pushl bin
    pushl $formatPrintfByte
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp

    incl vIndex
    jmp afis_binKey
et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80