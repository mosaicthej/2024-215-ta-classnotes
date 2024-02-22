	.file	"printfloat.c"
	.option nopic
	.attribute arch, "rv32i2p1_f2p2_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	time2
	.type	time2, @function
time2:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	# s0 is used as fp.
	fsw	fa0,-20(s0) # allocated for x
	flw	fa5,-20(s0) # temp
	fadd.s	fa5,fa5,fa5 # 2*x
	fmv.s	fa0,fa5 # result 
	lw	s0,28(sp) # restore fp
	addi	sp,sp,32
	jr	ra # return
	.size	time2, .-time2
	.globl	__extendsfdf2
	.section	.rodata
	.align	2
.LC1:
	.string	"%f"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32  # use s0 as fp
	lui	a5,%hi(.LC0) # upperhalf of 3.14
	flw	fa5,%lo(.LC0)(a5) # lowerhalf of 3.14. Now, fa5 has 3.14
	fsw	fa5,-20(s0) # store it (p) -> onto fp-20
	flw	fa0,-20(s0) # arg reg
	call	time2     # call func. (arg in fa0)
	fsw	fa0,-24(s0) # store result (m)
	li	a5,1        # placeholder
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	addi	a5,a5,5
	sw	a5,-28(s0)  # placeholder
	flw	fa0,-20(s0) # bring (p) <- fp-20 onto fa0
	call	__extendsfdf2 # this returns a double (extends it to double)
	mv	a4,a0 # lower half
	mv	a5,a1 # upper half
	mv	a2,a4 # lo
	mv	a3,a5 # hi
	lui	a5,%hi(.LC1)
	addi	a0,a5,%lo(.LC1) # "%f" format str
	# before call: a0 points to str "%f",
	# a2 holds %lo[p] and a3 holds %hi[p]
	call	printf
	li	a5,0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.section	.rodata
	.align	2
.LC0:
	.word	1078523331
	.ident	"GCC: (g2ee5e430018) 12.2.0"
