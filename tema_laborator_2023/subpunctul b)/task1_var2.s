.data
    nr: .space 4
    bin: .space 32 ;# 8 * 4
    binIndex: .space 4
    mIndex: .space 4
    v: .space 32
    vIndex: .space 4
    messageLenght: .space 4
    message: .asciz "parola"

    formatMesajInit: .asciz "%s\n"
    formatPrintf: .asciz "%ld "
    formatStrlen: .asciz "lungime: %ld\n"
    formatBinary: .asciz "%s"
    newSpace: .asciz " "
    newLine: .asciz "\n"
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
    push $formatMesajInit
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
    
    movl %eax, messageLenght
    
afis_strlen_mesaj:    
    pusha
    push messageLenght
    push $formatStrlen
    call printf
    addl $8, %esp
    popa

    pushl $0
    call fflush
    addl $4, %esp
    
    
    lea message, %edi
    movl $0, mIndex
for_caracter_mesaj: ;# for(mIndex=0; mIndex<messageLenght; mIndex++)
    movl mIndex, %ecx
    cmp %ecx, messageLenght
    je afis_vector_v_nr
    
    ;# fiecare caracter e indicat prin pozitia (%edi + %ecx)
    movzbl (%edi, %ecx), %ebx ;# valoarea ASCII a caracterului curent se va afla in ebx, iar in ecx e counter-ul MIndex; move zero-extended byte to zero va completa cu zero-uri pana la 32 de biti
    
        lea v, %esi
    compunere_vector_v_nr:
        movl %ebx, (%esi, %ecx, 4)
        
    ;#afis_secv_caractere:   
        ;#pusha
        ;#pushl %ebx
        ;#pushl $formatPrintf
        ;#call printf
        ;#addl $8, %esp
        ;#popa
        
        ;#pushl $0
        ;#call fflush
        ;#addl $4, %esp
        
cont_for_caracter_mesaj:
    incl mIndex
    jmp for_caracter_mesaj
    
    movl $1, %eax
    movl $4, %ebx
    movl $newLine, %ecx
    movl $2, %edx
    int $0x80


    lea v, %esi
    movl $0, vIndex
afis_vector_v_nr:
    movl vIndex, %ecx
    cmp %ecx, messageLenght
    je for_vIndex
    
    movl (%esi, %ecx, 4), %eax
    
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
    jmp afis_vector_v_nr


    lea v, %esi
    movl $0, vIndex
for_vIndex:
    movl vIndex, %ecx
    cmp %ecx, messageLenght
    je et_exit
    
        lea bin, %edi
        movl (%esi, %ecx, 4), %eax ;# fiecare element din vectorul v reprezinta elementul curent ce trebuie transformat in reprezentarea lui binara
        
        movl $7, %ecx
        movl $2, %ebx
        numar_in_binar:
            cmp $0, %eax
            je init_afis_numar_in_binar

            movl $0, %edx
            divl %ebx ;# mereu va fi impartit (edx, eax) la 2, de aceea edx trebuie reinitializat la fiecare pas
            
            ;# in edx se afla restul, iar in eax catul impartirii la ebx (= 2)
            movl %edx, (%edi, %ecx, 4) ;# deoarece counter-ul e parcurs descrescator, adica restul impartirii lui eax la 2 va fi concatenat de la stanga la dreapta (daca counter-ul era parcurs in mod obisnuit, ar fi fost nevoie de o inversiune ulterior a sirului generat)
            
            subl $1, %ecx
            jmp numar_in_binar
            
        init_afis_numar_in_binar: 
            lea bin, %edi
            movl $0, binIndex
        afis_numar_in_binar:
            movl binIndex, %ecx
            cmp $8, %ecx
            je cont_for_vIndex
            
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
            
            incl binIndex
            jmp afis_numar_in_binar
cont_for_vIndex:
    movl $1, %eax
    movl $4, %ebx
    movl $newSpace, %ecx
    movl $2, %edx
    int $0x80

    incl vIndex
    jmp for_vIndex
    
et_exit:
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
    

