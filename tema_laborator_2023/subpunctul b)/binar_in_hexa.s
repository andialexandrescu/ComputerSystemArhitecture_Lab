.data
    v: .byte 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1  # Vectorul cu grupuri de câte patru elemente 0 sau 1
    len: .byte 16    # Numărul total de elemente în vector (4 grupuri de câte 4 elemente)
    hex_repr: .byte 5 ;#(len/4)+1  # Alocăm spațiu pentru reprezentarea hexadecimală (un byte pentru fiecare grup de 4 + 1 pentru terminatorul nul)
.text
.global main

main:
    movl $0, %ecx        # Inițializăm contorul la 0
    leal v, %esi          # Adresa vectorului v
    leal hex_repr, %edi   # Adresa pentru reprezentarea hexadecimală

convert_loop:
    movl $0, %eax         # Inițializăm registrul EAX cu 0 pentru a forma valoarea hexazecimală

    # Încărcăm fiecare element din grup și îl adăugăm la valoarea hexazecimală în formare
    movb (%esi,%ecx), %al
    shl $1, %eax
    orl %eax, %ecx

    movb 1(%esi,%ecx), %al
    shl $1, %eax
    orl %eax, %ecx

    movb 2(%esi,%ecx), %al
    shl $1, %eax
    orl %eax, %ecx

    movb 3(%esi,%ecx), %al
    shl $1, %eax
    orl %eax, %ecx

    # Convertim valoarea hexazecimală într-un caracter ASCII și o stocăm în hex_repr
    movl $16, %edx        # Divizorul pentru conversia în hexazecimal (16)
    divl %edx             # Împărțim valoarea hexazecimală din ECX la 16

    addb $'0', %al        # Adăugăm caracterul '0' pentru cifrele de la 0 la 9
    cmpb $9, %al
    jbe is_digit
    addb $'A' - 10, %al   # Pentru literele A-F, ajustăm pentru literele ASCII

is_digit:
    movb %al, (%edi,%ecx)  # Stocăm caracterul în reprezentarea hexadecimală

    incl %ecx                # Incrementăm contorul pentru următorul grup de 4
    cmpl $len, %ecx           # Verificăm dacă am terminat conversia pentru toate grupurile
    jl convert_loop           # Dacă nu, continuăm conversia

    movb $0, (%edi,%ecx)    # Adăugăm terminatorul nul pentru a forma un șir C-style

    # Afișarea valorii hexazecimale
    movl $4, %eax          # Codul pentru sys_write
    movl $1, %ebx          # Descriptorul de fișier pentru stdout (1)
    movl $hex_repr, %ecx   # Adresa începutului reprezentării hexazecimale
    movl $20, %edx      # Numărul de caractere de afișat (un sfert din lungimea vectorului)
    int $0x80              # Apelați funcția de sistem

    # Ieșirea din program
    movl $1, %eax      # Codul pentru sys_exit
    xor %ebx, %ebx
    int $0x80           # Apelați funcția de sistem
