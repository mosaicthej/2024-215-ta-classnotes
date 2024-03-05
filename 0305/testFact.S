.include "syscall.h"

.globl _start
_start:
	li	a7, SYS_readInt
	ecall

	# num in a0
	call	fact

	li	a7, SYS_printInt
	ecall

	li	a0, 0
	li	a7, SYS_exit
	ecall
