.data
.text
.global main
main:
	movl $0, %eax
	mov $1, %ah

	mov $1, %eax
	mov $0, %ebx
	int $0x80
