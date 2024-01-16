.data
sir : .space 404
sir_inv : .space 404
length: .space 4
sirIndex: .space 4
sir_invIndex: .space 4

formatScanf: .asciz "%s"
formatPrintf: .asciz "%s\n"
.text
.global main
main:

pushl $sir ;# sirul e introdus de la tastatura
pushl $formatScanf
call scanf
addl $8, %esp

pushl $sir  ;# lungimea sirului
call strlen
addl $4, %esp
mov %eax, length

lea sir, %esi
lea sir_inv, %edi

movl length, %edx
movl %edx, sirIndex
subl $1, sirIndex ;# se incepe de pe poz sir[length-1]
movl $0, sir_invIndex ;# sir_inv[0]
for_invers:;# for(int sirIndex=length-1; sirIndex>=0; sirIndex--)
    movl sirIndex, %ecx
    cmpl $0, %ecx
    jl afisare_sir_inv

    movl sirIndex, %ebx
    ;# extragere caracter din sir
    movb (%esi, %ebx, 1), %al # in al u un caracter
    ;# mutare caracter din sir in sir_inv
    movl sir_invIndex, %ecx
    movb %al, (%edi, %ecx, 1)

    incl sir_invIndex
    decl sirIndex
    jmp for_invers

afisare_sir_inv:
push $sir_inv
push $formatPrintf
call printf 
addl $8, %esp

pushl $0
call fflush
addl $4, %esp

et_exit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80