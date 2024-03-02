.globl Derivative
# get the derivative of a function at x
# @args: a0 - (float) x
#        a1 - pointer to a function: float->float
# 	 a2 - (float) the h value to use (for differentiation)
# @ret : a0 - (float) df/dx f(x)
Derivative:
# calculate f(x);
# calculate f(x+h)
# ret (f(x+h) - f(x)) /h
#
# need to save on stack (across calls)
# ra, fp, 
# frame: x, funPointer, f(x) (or f(x+h))
#
# layout:   x 	    -> s2  -> fp-4
# 	 funPointer -> s3  -> fp-8
#           h       -> s4  -> fp-12
#         f(x)      -> s5  -> fp-16
	addi sp, sp, -8
	sw   ra, 4(sp)
	sw   fp, 0(sp)
	mv   fp, sp
	addi sp, sp, -16 # need place for 2 things
	sw   s2, -4(fp)  # <- x
	sw   s3, -8(fp)  # <- funPointer
	sw   s4, -12(fp) # <- h
	sw   s5, -16(fp) # <- f(x)
# we could do this without using s-reg but we want,
# to have the memory access to be grouped together,
# so it's better on the cache, and better performance.
# on good chips, those instruction together might 
# just take 1 read cycle (block-read)

# since a0 now has x (as bit pattern in int reg)
# it is comformant with our ABI.
# just call the function 
# (but first, we want to save funPointer and x)
mv   s2, a0 # s2 <- x
mv   s3, a1 # s3 <- funPointer
mv   s4, a2 # s4 <- h
	jalr ra, 0(a1) # call *funPointer
	# now returned, and a0 have f(x)
mv   	  s5, 	a0   # s5 <- f(x)
fmv.s.x   ft0, 	s4  # s4 -> h -> ft0
mv   	  s3, 	a1   # s3 -> funPointer
fmv.s.x	  ft1, 	s2  # s2 -> x -> ft1
# because we need to get x+h (as float), 
# so we need to put them into f-register.
fadd.s    ft0, 	ft1, ft0 # ft0 <- x+h
# this our x_new, put it in a0
fmv.x.s   a0, 	ft0
# now get f(x_new) = f(x+h)
	jalr ra, 0(a1)
	# now returned, and a0 have f(x+h)
fmv.s.x   ft0, 	a0 # ft0 <- f(x+h)
fmv.s.x   ft1, 	s5 # ft1 <- f(x)
fsub.s    ft0, 	ft0, ft1  # ft0 <- f(x+h) - f(x)
fmv.s.x   ft1, 	s4 # ft1 <- h
fdiv.s    ft0, 	ft0, ft1  # ft0 <- (f(x+h)-f(x))/h
# ft0 has our answer, f'(x)
fmv.x.s   a0,	ft0 # return val

# now restore stack
	lw   s5, -16(fp)
	lw   s4, -12(fp)
	lw   s3, -8 (fp)
	lw   s2, -4 (fp)
	addi sp, sp, 16
	mv   sp, fp
	lw   fp, 0(sp)
	lw   ra, 4(sp)
	addi sp, sp, 8
ret
