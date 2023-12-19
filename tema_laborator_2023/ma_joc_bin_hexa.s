.data
    binaryValue: .byte 0b00000111
    formatPrintf: .asciz "%s\n"
    buffer: .space 9  # Alocăm spațiu pentru reprezentarea binară (8 caractere + terminator nul)

.text
.global main
main:
    # Copiați valoarea binară din .data în registrul al
    movb binaryValue, %al

    # Inițializați buffer-ul cu terminatorul nul
    movl $8, %ecx        # Numărul de biți (folosim 8 pentru un byte)
    leal buffer, %edi    # Adresa de destinație a buffer-ului
    movb $0, (%edi,%ecx) # Adăugăm terminatorul nul la sfârșitul buffer-ului

convertLoop:
    testl %ecx, %ecx     # Verificați dacă s-au procesat toți cei 8 de biți
    jz printBinary       # Dacă da, afișăm reprezentarea binară

    shrb %al             # Împingeți cel mai puțin semnificativ bit în carry flag (CF)
    rclb $1, (%edi,%ecx) # Rotire la stânga cu un bit și stocați rezultatul în buffer
    dec %ecx             # Scădeți numărul de biți rămași
    jmp convertLoop      # Continuați cu următorul bit

printBinary:
    # Apelați printf pentru a afișa reprezentarea binară
    pusha
    leal buffer, %ecx    # Adresa începutului reprezentării binare
    pushl %ecx
    pushl $formatPrintf
    call printf
    addl $12, %esp
    popa

exit:
    movl $1, %eax        # Codul pentru sys_exit
    xorl %ebx, %ebx      # Status 0
    int $0x80            # Apelați funcția de sistem
