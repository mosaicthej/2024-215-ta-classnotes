.globl euler
#@arg: a0: number n (int)
#@arg: a0: euler's approx (float) 

euler:
	# use s2 for k,
	# use s3 for n, (actually n+1)
	# use fs2 for accu

# since calls other fn, need to save ra as well
# so 4 words on stack
addi	sp, sp, -16
sw	ra, 12(sp)
fsw	fs2, 8(sp) # use fsw to store f reg
sw	s2, 4(sp)
sw	s3, 0(sp)

	addi	s3, a0, 1 # n+1 here
	mv	s2, zero

	fmv.s.x		fs2, zero 
	# fs2 will be accumulator

	euler_loop:
		# s0 is k
		# get k!
		mv 	a0, s2
		call	fact # k!
		# when it gets to here, a0 is the k!
		call 	inv
		# when it gets to here, a0 is the 1/(k!)
		
		fmv.s.x		ft0, a0 # now ft0 is 1/(k!)
		fadd.s		fs2, ft0, fs2	# accu += 1/(k!)

		# if k > n, or, (k+1 > n+1), exit
		addi	s2, s2, 1
		bge	s3, s2, euler_loop
		# otherwise, done
euler_done:
	# done now, accu is in fs2
	# need to move this to a0 for return
	fmv.x.s	a0, fs2 # a0 now has (pattern for fs2)
# fix stack
lw	s3, 0(sp)
lw	s2, 4(sp)
flw	fs2, 8(sp)
lw	ra, 12(sp)
addi	sp, sp, 16
ret # return to caller


# @arg: a0: number n (int)
# @ret: a0: (1/n) float pattern
inv:
	fcvt.s.w	fa0, a0 # **convert** a0 into fa0
	fli.s		ft0, 1.0
	fdiv.s		fa0, ft0, fa0
	fmv.x.w		a0, fa0	# move fa0 into a0
	ret



