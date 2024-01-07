.data
messageLength: .long 10

hexRez: .space 11
hexRez0xF: .space 11
binRez: .long 67, 237, 145, 87, 162, 82, 238, 130, 91, 175;# parolabaca xor-ata cu key din input.txt
decRez: .space 4
vIndex: .space 4
i: .space 4
j: .space 4

cript: .asciz "0x"
chZero: .asciz "0"
formatPrintf: .asciz "%ld "
formatPrintfCript: .asciz "%s"
formatPrintfDigit: .asciz "%d"
formatPrintfAlpha: .asciz "%c"

.text
.global main

main:
    pusha
    pushl $cript
    pushl $formatPrintfCript
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp
    
init_for_vIndex3:    
    movl $0, i
    movl $0, j;# binRez0xF[]
    movl $0, vIndex
for_vIndex3:
    movl vIndex, %ecx
    cmpl %ecx, messageLength
    je et_exit

    lea binRez, %esi
    movl (%esi, %ecx, 4), %eax
    movl %eax, decRez

testare_decRez:
    cmpl $0, decRez
    je cont_hexaRez

    lea hexRez, %edi

    movl decRez, %eax
    andl $0xF, %eax
    movl i, %edx
    movl %eax, (%edi, %edx)
    
    ;# afisare hexRez
    ;#pusha
    ;#pushl %eax
    ;#pushl $formatPrintf
    ;#call printf
    ;#addl $8, %esp
    ;#popa
    
    ;#pushl $0
    ;#call fflush
    ;#addl $4, %esp
    
    shrl $4, decRez
    cmpl $0, decRez
    jne compunere_hexRez0xF
    
    cmpl $0, decRez
    je et_index_i
et_intoarcere_testare_decRez:
    jmp testare_decRez
et_index_i:
    incl i
    jmp et_intoarcere_testare_decRez
compunere_hexRez0xF:    
    lea hexRez0xF, %esi
    movl j, %ebx
    movl %eax, (%esi, %ebx)
    incl j
    jmp et_intoarcere_testare_decRez

cont_hexaRez:
    lea binRez, %esi
    movl vIndex, %ecx
    cmpl $0, (%esi, %ecx, 4)
    je exceptie_zero
    
    lea binRez, %esi
    movl vIndex, %ecx
    cmpl $16, (%esi, %ecx, 4)
    jl exceptie_mai_mic_16
    
    movl i, %ecx
    subl $1, %ecx
    lea hexRez, %edi
    movl (%edi, %ecx), %eax
    cmpl $10, %eax
    jl afis_format_cifra1
    jmp afis_format_litera1
    et_intoarcere:
        lea hexRez0xF, %edi
        movl j, %ecx
        subl $1, %ecx
        movl (%edi, %ecx), %eax
        cmpl $10, %eax
        jl afis_format_cifra2
        jmp afis_format_litera2

cont_for_vIndex3:
    incl vIndex
    jmp for_vIndex3

afis_format_cifra1:
    pusha
    pushl %eax
    pushl $formatPrintfDigit
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp

    jmp et_intoarcere

afis_format_litera1:
    pusha
    addl $55, %eax
    pushl %eax
    pushl $formatPrintfAlpha
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp

    jmp et_intoarcere
afis_format_cifra2:
    pusha
    pushl %eax
    pushl $formatPrintfDigit
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp

    jmp cont_for_vIndex3

afis_format_litera2:
    pusha
    addl $55, %eax
    pushl %eax
    pushl $formatPrintfAlpha
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp

    jmp cont_for_vIndex3
exceptie_zero:
    movl $4, %eax
    movl $1, %ebx
    movl $chZero, %ecx
    movl $2, %edx
    int $0x80
    
    movl $4, %eax
    movl $1, %ebx
    movl $chZero, %ecx
    movl $2, %edx
    int $0x80
    
    jmp cont_for_vIndex3
exceptie_mai_mic_16:
    movl $4, %eax
    movl $1, %ebx
    movl $chZero, %ecx
    movl $2, %edx
    int $0x80
    
    lea binRez, %esi
    movl vIndex, %ecx
    movl (%esi, %ecx, 4), %ebx
    
    cmpl $10, %ebx
    jge afis_intre_10_16
    
    pusha
    pushl %ebx
    pushl $formatPrintfDigit
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp
    jmp skip_afis_10_16
    afis_intre_10_16:
    pusha
    addl $55, %ebx
    pushl %ebx
    pushl $formatPrintfAlpha
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp
skip_afis_10_16:
    jmp cont_for_vIndex3
et_exit:
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
