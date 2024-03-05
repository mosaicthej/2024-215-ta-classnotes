
.globl fact
# @args: a0: number given, k
# @ret:  a0: k! = k * (k-1)!, if k > 0
fact:
addi	sp, sp, -8
sw	ra, 4(sp)
sw	fp, 0(sp)
mv	fp, sp
	addi 	sp, sp, -4
	sw	a0, -4(fp) # k lives here.

	# ble	a0, zero, fact_zero # if k<=0, goes to base case
	blt	zero, a0, fact_body
	fact_zero:
	# if here, a0 is < = 0
	# return 1
	li	a0, 1
	j	fact_ret

	fact_body:
	# if we got here, it is greater than 0. Not base case
	# a0 is already number k
	addi	a0, a0, -1 # k-1
	call	fact # (k-1)!
	# at this point, a0 is (k-1)!

	lw	t0, -4(fp)	 # t0 <- k, and a0 <- (k-1)!
	mul 	a0, a0, t0	# a0 <- k * (k-1)!
	# good to return

fact_ret:
# retstore stacks before ret
	addi	sp, sp, 4 	# no longer need the k
lw	fp, 0(sp)
lw	ra, 4(sp)
addi	sp, sp, 8
ret
