	.file	"printfloat.c"
	.option nopic
	.attribute arch, "rv32i2p1_f2p2_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	time5
	.type	time5, @function
time5:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	flw	fa4,-20(s0)
	lui	a5,%hi(.LC0)
	flw	fa5,%lo(.LC0)(a5)
	fmul.s	fa5,fa4,fa5
	fmv.x.s	a0,fa5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	time5, .-time5
	.globl	__extendsfdf2
	.section	.rodata
	.align	2
.LC2:
	.string	"%f"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	lui	a5,%hi(.LC1)
	flw	fa5,%lo(.LC1)(a5)
	fsw	fa5,-20(s0)
	lw	a0,-20(s0)
	call	time5
	sw	a0,-24(s0)
	li	a5,1
	sw	a5,-28(s0)
	lw	a5,-28(s0)
	addi	a5,a5,5
	sw	a5,-28(s0)
	lw	a0,-20(s0)
	call	__extendsfdf2
	mv	a4,a0
	mv	a5,a1
	mv	a2,a4
	mv	a3,a5
	lui	a5,%hi(.LC2)
	addi	a0,a5,%lo(.LC2)
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
	.word	1084227584
	.align	2
.LC1:
	.word	1078523331
	.ident	"GCC: () 13.2.0"
