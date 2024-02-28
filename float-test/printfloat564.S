	.file	"printfloat.c"
	.option nopic
	.attribute arch, "rv64i2p1_f2p2_d2p2_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	time5
	.type	time5, @function
time5:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	fsw	fa0,-20(s0) # store fa0 to fp.
	flw	fa4,-20(s0) # load (x) into fa4
	lui	a5,%hi(.LC0) # const 5
	flw	fa5,%lo(.LC0)(a5)
	fmul.s	fa5,fa4,fa5 # do 5*x 
	fmv.s	fa0,fa5 # move to fa0 (return)
			# here, as the abi allows.
			# we can have return val in fa0.
	ld	s0,24(sp) 
	addi	sp,sp,32 
	jr	ra 
	.size	time5, .-time5
	.section	.rodata
	.align	3
.LC2:
	.string	"%f"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	lui	a5,%hi(.LC1)
	flw	fa5,%lo(.LC1)(a5)
	fsw	fa5,-20(s0)
	flw	fa0,-20(s0)
	call	time5
		# with `mabi` allowing `d` extension
		# floating points can be directly passed as
		# function arguments.
		# similar as in above `time5` function,
	fsw	fa0,-24(s0)
	li	a5,1
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	addiw	a5,a5,5
	sw	a5,-28(s0)
	flw	fa5,-20(s0)
	fcvt.d.s	fa5,fa5 # extend to double
	fmv.x.d	a1,fa5 # move the pattern to a1
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2) # this is the string "%f"
	call	printf
		# however, library calls (and system calls)
		# are not necessary compliant with the abi
		# therefore still need to first move the bit
		# pattern into a integer register.
		# then send it to `printf`
	li	a5,0
	mv	a0,a5
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.section	.rodata
	.align	2
.LC0:
	.word	1084227584
	.align	2
.LC1:
	.word	1078523331
	.ident	"GCC: () 13.2.0"
