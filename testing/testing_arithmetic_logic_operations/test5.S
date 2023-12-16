.data
    	x: .long 0xFFFF1234
	shr_biti: .space 4
	shl_biti: .space 4
	sar_biti: .space 4
	sal_biti: .space 4
.text
.global main
main:
	mov x, %eax
	shr $4, %eax
	mov %eax, shr_biti

	mov x, %eax
	shl $4, %eax
	mov %eax, shl_biti

	mov x, %eax
	sar $4, %eax
  	mov %eax, sar_biti

	mov x, %eax
	sal $4, %eax
  	mov %eax, sal_biti

	mov $1, %eax
	xor %ebx, %ebx
	int $0x80
