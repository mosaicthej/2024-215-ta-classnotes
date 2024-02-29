.equ SYS_exit,      93
.equ SYS_printInt,  244
.equ SYS_readInt,   245
.equ SYS_printChar, 246
.equ SYS_readChar,  247
.equ SYS_printStr,  248
.equ SYS_readStr,   249
.equ SYS_printFloat,250
.equ SYS_readFloat, 251

.section .data
promptInt: .string "\nEnter an integer "
promptFlt: .string "\nEnter a float "
stInt: .string "\npi times int is: "
stFlo: .string "\npi times float is: "

pi: .float 3.14159265358979323846

.section .text
.globl _start
_start:
# testing:
# read an int
# read an float
# print product int * pi
# print product float * pi
	# 2 ways to do:
	fli.s     ft2, 0x1p-3 # this is 0.125 = 2^-3
	# you can also do scientific notation
	# fli   ft2, 6.02e-23
	# however, this requires _zfa extension
	# https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md#load-floating-point-immediate

	# or load from memory
	la 	t0, pi
	flw	ft2, 0(t0) 
	# just like how you load a number


li	a7,  SYS_printStr
la 	a0,  promptInt
  ecall
  blt   a0, zero, _printErr

li 	a7,  SYS_readInt
  ecall
  beq   a0, zero, _readZero
mv      t0, a0  # t0 <- int



li 	a7,  SYS_printStr
la 	a0,  promptFlt
  ecall
  blt  a0, zero, _printErr
li 	a7, SYS_readFloat
  ecall
  beq  a0, zero, _readZero
	mv 	t1, a0 # t1 <- float

	fcvt.s.w ft0, t0 # the int
	fmv.s.x  ft1, t1 # the float
	
	# int * pi -> ft0
	fmul.s   ft0, ft0, ft2

	# float * pi -> ft1
	fmul.s   ft1, ft1, ft2

li 	a7, SYS_printStr
la	a0, stInt
  ecall
  blt 	a0, zero, _printErr

li	a7, SYS_printFloat
fmv.x.s a0, ft0 # int * pi
  ecall
  blt	a0, zero, _printErr


li	a7, SYS_printStr
la	a0, stFlo
  ecall
  blt 	a0, zero, _printErr

li	a7, SYS_printFloat
fmv.x.s a0, ft1 # float * pi
  ecall
  blt	a0, zero, _printErr

li	a7, SYS_exit
ecall
	
	
	
	


_printErr:# to handle printError

_readZero:# read returns 0. This is either
# read got an EOF, or user entered 0.

li 	a7, SYS_exit
ecall # exit for errors

