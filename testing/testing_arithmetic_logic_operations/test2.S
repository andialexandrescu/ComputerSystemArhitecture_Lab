.data
	x: .long 12
	y: .long 8
	si: .space 4
	sau: .space 4
	not_op_x: .space 4
	not_op_y: .space 4
	sau_exclusiv: .space 4
.text
.global main
main:
	mov x, %eax
	not %eax
	mov %eax, not_op_x
	mov y, %eax
	not %eax
	mov %eax, not_op_y

	mov x, %eax
	and y, %eax
	mov %eax, si

	mov x, %eax
	or y, %eax
	mov %eax, sau

	mov x, %eax
	xor y, %eax
	mov %eax, sau_exclusiv

	jmp et_exit
et_exit:
	mov $1, %eax
	mov $0, %ebx
	int $0x80
