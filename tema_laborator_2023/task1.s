.data
    bin: .space 9
    mIndex: .space 4
    bitIndex: .space 4
    messageLenght: .space 4
    message: .asciz "parola"

    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "mesaj: %s\n"
    formatStrlen: .asciz "lungime: %ld\n"
    formatBinary: .asciz "%s "
.text
strlen:
    movl $0, %ecx 
    movl 4(%esp), %ebx

    for_strlen:
        movb (%ebx), %al 
        cmpb $0, %al ;# counter care va fi incrementat cat timp sirul e diferit de caracterul null
        je strlen_exit
        
        incl %ecx
        incl %ebx
        jmp for_strlen
strlen_exit:
        movl %ecx, %eax ;# valoarea din final a counter-ului se va afla in %eax
        ret
.global main
main:
afis_mesaj:
    pusha
    lea message, %eax
    push %eax
    push $formatPrintf
    call printf
    addl $8, %esp
    popa
    
    pushl $0
    call fflush
    addl $4, %esp
    
strlen_mesaj:
    lea message, %edi ;# message se afla la inceputul adresei %edi/ e relativ la %edi
    push %edi
    call strlen
    add $4, %esp
    
    pusha
    push %eax
    push $formatStrlen
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp
    
    movl $0, mIndex
for_caracter_mesaj: ;# for(MIndex=0; MIndex<strlen(message); MIndex++)
    movl mIndex, %ecx
    cmp %ecx, messageLenght
    je et_exit
    
    lea message, %edi
    ;# fiecare caracter e indicat prin pozitia (%edi + %ecx)
    movzbl (%edi, %ecx), %ebx ;# valoarea ASCII a caracterului curent se va afla in %ebx, iar in %ecx e counter-ul MIndex; move zero-extended byte to zero va completa cu zero-uri pana la 32 de biti
    
    movl $7, bitIndex
    for_ascii_in_binar:;# for(bitIndex=7; bitIndex>=0; bitIndex--) parcurgere inversa pt a evita o inversare de care ar fi fost nevoie ulterior
        lea bin, %esi
        movl bitIndex, %ecx
        cmpl $0, %ecx
        je cont_for_caracter_mesaj
        
        ;# in %eax au loc prelucrarile
        ;# eax = (caracter_mesaj & 0x1) + '0'
        movl %ebx, %eax
        andl $1, %eax ;# pt LSB
        addl $'0', %eax ;# convertire in '0' sau '1' (dpdv ASCII)
        movb %al, (%esi, %ecx) ;# bin e relativ la %esi
        
        shrl %ebx ;# urmatorul bit din caracter
        decl bitIndex
        jmp for_ascii_in_binar
        
cont_for_caracter_mesaj:
    pusha
    pushl %esi
    pushl $formatBinary
    call printf
    addl $8, %esp
    popa 
    
    push $0
    call fflush
    add $4, %esp

    incl mIndex
    jmp for_caracter_mesaj
    
et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
    

