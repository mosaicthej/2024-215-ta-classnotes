#include "syscall.h"

.globl _start
_start:
	li	a7, SYS_readInt
	ecall


