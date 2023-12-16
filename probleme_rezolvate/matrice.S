;# Bogdan Macovei: https://www.youtube.com/watch?v=r5ndwQa9vdQ  |  https://www.youtube.com/watch?v=tENj2R-ixDc 
.data
    lines: .long 3
    columns: .long 4
    lineIndex: .space 4
    columnIndex: .space 4
    matrix: .long 10,20,30,40
            .long 50,60,70,80
            .long 90,100,110,120
    formatInt: .asciz "%d "
    newLine: .asciz "\n"
.text
.global main
main:
    lea matrix, %edi ;# incarcare matrice in registrul edi (adr_inceput)
    movl $0, lineIndex ;# initializare indice linii
for_lines: ;# for(int lineIndex=0; lineIndex<lines; lineIndex++)
    movl lineIndex, %ecx
    cmp %ecx, lines ;# if(lineIndex==lines) jmp et_exit
    je et_exit
    
    movl $0, columnIndex ;# initializare indice coloane
    for_columns: ;# for(int columnIndex=0; columnIndex<columns; columnIndex++)
    movl columnIndex, %ecx
    cmp %ecx, columns ;# if(lineIndex==lines) jmp cont_for_lines
    je cont_for_lines
    
    ;# prelucrarea efectiva
    ;# afisare element curent = lineIndex * columns + columnIndex relativ la adresa de inceput a matricei, adica %edi
    movl lineIndex, %eax
    mull columns ;# eax = eax * columns = lineIndex * columns
    addl columnIndex, %eax
    
    movl (%edi, %eax, 4), %ebx ;# in ebx se afla elementul curent
    
    pushl %ebx
    pushl $formatInt
    call printf
    add $8, %esp
    
    pushl $0
    call fflush
    add $4, %esp
    
    incl columnIndex
    jmp for_columns
    
cont_for_lines:
    ;# afisare new line cand se trece la o noua linie
    mov $4, %eax
    mov $1, %ebx
    mov $newLine, %ecx
    mov $2, %edx
    int $0x80

    incl lineIndex
    jmp for_lines

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80