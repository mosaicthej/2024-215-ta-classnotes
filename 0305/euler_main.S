.equ SYS_exit,      93
.equ SYS_printInt,  244
.equ SYS_readInt,   245
.equ SYS_printChar, 246
.equ SYS_readChar,  247
.equ SYS_printStr,  248
.equ SYS_readStr,   249
.equ SYS_printFloat,250
.equ SYS_readFloat, 251


.globl _start
_start:
# read an int -> n
# print out euler(n) as float
# do 10 decimal precision
li	a7, SYS_readInt
ecall

# a0 will contain the number
call	euler

# a0 will contain the euler(n)
li	a7, SYS_printFloat
li	a2, 10 # 10 precision
ecall


li	a0, 0
li	a7, SYS_exit
ecall
