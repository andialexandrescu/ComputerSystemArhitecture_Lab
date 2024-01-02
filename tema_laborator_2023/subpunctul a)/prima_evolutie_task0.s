.data
    m: .space 4 ;# 1<=m<=18 linii
    n: .space 4 ;# 1<=n<=18 coloane
    p: .space 4 ;# p<=m*n deoarece exista cazul in care matricea are toate celulele vii, deci nr total de perechi e nrlinii*nrcoloane
    pIndex: .space 4
    matrix: .space 1600 ;# (18+2) * (18+2) * 4
    lineIndex: .space 4
    columnIndex: .space 4
    i: .space 4
    j: .space 4 ;# matrix[i][j], respectiv matrixs[i][j]
    k: .space 4 ;# k<=15
    kIndex: .space 4
    s: .space 4 ;# folosit pentru suma vecinilor
    matrixs: .space 1600

    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld "
    newLine: .asciz "\n"
    textIteration: .asciz "Iteratie %ld\n" ;# printf
    textMatrix: .asciz "matrix<%ld>:\n"
    textMatrixS: .asciz "matrixs<%ld>:\n"
.text
.global main
main:
    ;# citire m linii
    pushl $m
    pushl $formatScanf
    call scanf
    add $8, %esp

    ;# citire n coloane
    pushl $n
    pushl $formatScanf
    call scanf
    add $8, %esp

    ;# citire p - nr celule vii
    pushl $p
    pushl $formatScanf
    call scanf
    add $8, %esp

    movl $0, pIndex
    addl $2, m
    addl $2, n
for_perechi: ;# for(pIndex=0; pIndex<p; pIndex++)
    movl pIndex, %ecx
    cmp %ecx, p
    je citire_k

    ;# citire pozitiile din matrice la care se afla celulele vii
    pushl $i
    pushl $formatScanf
    call scanf
    add $8, %esp

    pushl $j
    pushl $formatScanf
    call scanf
    add $8, %esp

    ;# for(i=0; i<m_init+2; i++){ for(j=0; j<n_init+2; j++) ... }
    ;# matrix[i+1][j+1] = 1 (celula vie); eax = (i+1) * (n_init+2) + (j+1); GRAF ORIENTAT
    addl $1, i
    movl i, %eax
    movl $0, %edx ;# pt a nu afecta inmultirea
    mull n
    addl $1, j
    addl j, %eax
    lea matrix, %edi
    movl $1, (%edi, %eax, 4)
    subl $1, j
    subl $1, i

    incl pIndex
    jmp for_perechi
citire_k:
    ;# citire k - nr evolutii
    pushl $k
    pushl $formatScanf
    call scanf
    add $8, %esp

afis_matrice_config_extinsa:
    movl $0, lineIndex
    for_linii: ;# for(lineIndex=0; lineIndex<m_init+2; lineIndex++)
        movl lineIndex, %ecx
        cmp %ecx, m
        je afis_matrice_config_init

        movl $0, columnIndex
        for_coloane: ;# for(columnIndex=0; columnIndex<n_init+2; columnIndex++)
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont_for_linii

            ;# eax = lineIndex * n + columnIndex
            movl lineIndex, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax

            lea matrix, %edi
            movl (%edi, %eax, 4), %ebx

            pusha
            pushl %ebx
            pushl $formatPrintf
            call printf
            add $8, %esp
            popa

            pushl $0
            call fflush
            popl %ebx
            
            incl columnIndex
            jmp for_coloane

    cont_for_linii:
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80
	
        incl lineIndex
        jmp for_linii

afis_matrice_config_init:
    movl $4, %eax
    movl $1, %ebx
    movl $newLine, %ecx
    movl $2, %edx
    int $0x80
        
    subl $2, m
    subl $2, n
    movl $0, lineIndex
    for2_linii: ;# for(lineIndex=0; lineIndex<m_init; lineIndex++)
        movl lineIndex, %ecx
        cmp %ecx, m
        je afis_k_evolutii ;# afis_suma_vecini_elem_curent

        movl $0, columnIndex
        for2_coloane: ;# for(columnIndex=0; columnIndex<n_init; columnIndex++)
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont_for2_linii

            ;# eax = (lineIndex+1) * (n_init+2) + (columnIndex+1) dar in mom acesta n a revenit la n_init, deci vom aduna, respectiv scadea 2 succesiv pt a nu produce schimbari asupra modului in care functioneaza eticheta for2_coloane
            movl lineIndex, %eax
            addl $1, %eax ;# evit sa il modific pe lineIndex direct
            movl $0, %edx
            addl $2, n
            mull n
            subl $2, n
            addl columnIndex, %eax
            addl $1, %eax

            lea matrix, %edi
            movl (%edi, %eax, 4), %ebx

            pusha
            pushl %ebx
            pushl $formatPrintf
            call printf
            add $8, %esp
            popa

            pushl $0
            call fflush
            popl %ebx
            
            incl columnIndex
            jmp for2_coloane

    cont_for2_linii:
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80
	
        incl lineIndex
        jmp for2_linii
;# afis_suma_vecini_elem_curent - indice 3 pt etichete - vezi fisier afis_suma_vecini_elem_curent.s

    movl $0, kIndex
afis_k_evolutii:
    movl kIndex, %ecx
    cmp %ecx, k
    je et_exit
    
    ;# prelucrari
    ;# MOD DE APELARE: compunere matrice s -> analiza evolutie -> afisare analiza evolutie 
    movl $4, %eax
    movl $1, %ebx
    movl $newLine, %ecx
    movl $2, %edx
    int $0x80
        
    pusha
    pushl kIndex
    pushl $textIteration
    call printf
    add $8, %esp
    popa
    
    push $0
    call fflush
    add $4, %esp
    
    jmp compunere_matrice_s
cont_afis_k_evolutii:
    incl kIndex
    jmp afis_k_evolutii
    
compunere_matrice_s: 
    movl $0, lineIndex
    for4_linii: ;# for(lineIndex=0; lineIndex<m_init; lineIndex++)
        movl lineIndex, %ecx
        cmp %ecx, m
        je afis_matrice_s

        movl $0, columnIndex
        for4_coloane: ;# for(columnIndex=0; columnIndex<n_init; columnIndex++)
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont_for4_linii
            
	    movl s, %ebx
	    addl $2, n

            ;# a[i-1][j-1] => (lineIndex) * (n_init+2) + (columnIndex)
            movl lineIndex, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# a[i-1][j] => (lineIndex) * (n_init+2) + (columnIndex+1)
            movl lineIndex, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax
            addl $1, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# a[i-1][j+1] => (lineIndex) * (n_init+2) + (columnIndex+2)
            movl lineIndex, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax
            addl $2, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# a[i][j-1] => (lineIndex+1) * (n_init+2) + (columnIndex)
            movl lineIndex, %eax
            addl $1, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# a[i][j+1] => (lineIndex+1) * (n_init+2) + (columnIndex+2)
            movl lineIndex, %eax
            addl $1, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax
            addl $2, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# a[i+1][j-1] => (lineIndex+2) * (n_init+2) + (columnIndex)
            movl lineIndex, %eax
            addl $2, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# a[i+1][j] => (lineIndex+2) * (n_init+2) + (columnIndex+1)
            movl lineIndex, %eax
            addl $2, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax
            addl $1, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# a[i+1][j+1] => (lineIndex+2) * (n_init+2) + (columnIndex+2)
            movl lineIndex, %eax
            addl $2, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax
            addl $2, %eax

            lea matrix, %edi
            addl (%edi, %eax, 4), %ebx
            
            ;# el curent din matrixs => (lineIndex+1) * (n_init+2) + (columnIndex+1)
            movl lineIndex, %eax
            addl $1, %eax
            movl $0, %edx
            mull n
            addl columnIndex, %eax
            addl $1, %eax
            
            lea matrixs, %edi
            movl %ebx, (%edi, %eax, 4)
            
            incl columnIndex
            subl $2, n
            jmp for4_coloane

    cont_for4_linii:
        incl lineIndex
        jmp for4_linii
afis_matrice_s:
    movl $4, %eax
    movl $1, %ebx
    movl $newLine, %ecx
    movl $2, %edx
    int $0x80
    
    pusha
    push kIndex
    pushl $textMatrixS
    call printf
    add $8, %esp
    popa
    
    push $0
    call fflush
    add $4, %esp
        
    movl $0, lineIndex
    for5_linii: ;# for(lineIndex=0; lineIndex<m_init; lineIndex++)
        movl lineIndex, %ecx
        cmp %ecx, m
        je analiza_evolutie

        movl $0, columnIndex
        for5_coloane: ;# for(columnIndex=0; columnIndex<n_init; columnIndex++)
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont_for5_linii

            ;# eax = (lineIndex+1) * (n_init+2) + (columnIndex+1)
            movl lineIndex, %eax
            addl $1, %eax
            movl $0, %edx
            addl $2, n
            mull n
            subl $2, n
            addl columnIndex, %eax
            addl $1, %eax

            lea matrixs, %edi
            movl (%edi, %eax, 4), %ebx

            pusha
            pushl %ebx
            pushl $formatPrintf
            call printf
            add $8, %esp
            popa

            pushl $0
            call fflush
            popl %ebx
            
            incl columnIndex
            jmp for5_coloane

    cont_for5_linii:
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80
	
        incl lineIndex
        jmp for5_linii
analiza_evolutie:
    movl $0, lineIndex
    for6_linii: ;# for(lineIndex=0; lineIndex<m_init; lineIndex++)
        movl lineIndex, %ecx
        cmp %ecx, m
        je afis_analiza_evolutie

        movl $0, columnIndex
        for6_coloane: ;# for(columnIndex=0; columnIndex<n_init; columnIndex++)
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont_for6_linii
            
            ;# eax = (lineIndex+1) * (n_init+2) + (columnIndex+1)
            movl lineIndex, %eax
            addl $1, %eax
            movl $0, %edx
            addl $2, n
            mull n
            subl $2, n
            addl columnIndex, %eax
            addl $1, %eax
   
            lea matrix, %edi
            movl (%edi, %eax, 4), %ebx
            
            ;# if (matrix[lineIndex+1][columnIndex+1]==1): jmp celula_vie else: jmp celula_moarta
            cmp $1, %ebx
            je celula_vie
            
            cmp $0, %ebx
            je celula_moarta
            
cont_analiza_evolutie:
	    ;#popl %ebx
            incl columnIndex
            jmp for6_coloane

    cont_for6_linii:
        incl lineIndex
        jmp for6_linii
celula_vie:
    ;#pushl %ebx
    ;# in ebx e elementul curent, adica celula vie, iar in eax e pozitia curenta a celulei
    lea matrixs, %esi
    movl (%esi, %eax, 4), %ebx
    
    cmp $2, %ebx
    jb elem_modif_in_0
    
    cmp $3, %ebx
    jg elem_modif_in_0
    
    cont_celula_vie:
        ;# popl %ebx
        jmp cont_analiza_evolutie
    
celula_moarta:
    ;#pushl %ebx
    ;# in ebx e elementul curent, adica celula moarta, iar in eax e pozitia curenta a celulei
    lea matrixs, %esi
    movl (%esi, %eax, 4), %ebx
    
    cmp $3, %ebx
    je elem_modif_in_1
    
    cont_celula_moarta:
        ;# popl %ebx
        jmp cont_analiza_evolutie
elem_modif_in_0:
    
    lea matrix, %edi
    movl $0, (%edi, %eax, 4)
    
    jmp cont_celula_vie
elem_modif_in_1:
    
    lea matrix, %edi
    movl $1, (%edi, %eax, 4)
    
    jmp cont_celula_moarta
afis_analiza_evolutie:
    movl $4, %eax
    movl $1, %ebx
    movl $newLine, %ecx
    movl $2, %edx
    int $0x80
    
    pusha
    push kIndex
    pushl $textMatrix
    call printf
    add $8, %esp
    popa
    
    push $0
    call fflush
    add $4, %esp
        
    movl $0, lineIndex
    for7_linii: ;# for(lineIndex=0; lineIndex<m_init; lineIndex++)
        movl lineIndex, %ecx
        cmp %ecx, m
        je cont_afis_k_evolutii

        movl $0, columnIndex
        for7_coloane: ;# for(columnIndex=0; columnIndex<n_init; columnIndex++)
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont_for7_linii

            ;# eax = (lineIndex+1) * (n_init+2) + (columnIndex+1)
            movl lineIndex, %eax
            addl $1, %eax
            movl $0, %edx
            addl $2, n
            mull n
            subl $2, n
            addl columnIndex, %eax
            addl $1, %eax

            lea matrix, %edi
            movl (%edi, %eax, 4), %ebx

            pusha
            pushl %ebx
            pushl $formatPrintf
            call printf
            add $8, %esp
            popa

            pushl $0
            call fflush
            popl %ebx
            
            incl columnIndex
            jmp for7_coloane

    cont_for7_linii:
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80
	
        incl lineIndex
        jmp for7_linii

et_exit:
    movl $1, %eax
    xor %ebx, %ebx
    int $0x80
