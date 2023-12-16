afis_suma_vecini_elem_curent:
    movl $4, %eax
    movl $1, %ebx
    movl $newLine, %ecx
    movl $2, %edx
    int $0x80
        
    movl $0, lineIndex
    for3_linii: ;# for(lineIndex=0; lineIndex<m_init; lineIndex++)
        movl lineIndex, %ecx
        cmp %ecx, m
        je compunere_matrice_s

        movl $0, columnIndex
        for3_coloane: ;# for(columnIndex=0; columnIndex<n_init; columnIndex++)
            movl columnIndex, %ecx
            cmp %ecx, n
            je cont_for3_linii
            
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
            subl $2, n
            jmp for3_coloane

    cont_for3_linii:
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80
	
        incl lineIndex
        jmp for3_linii
