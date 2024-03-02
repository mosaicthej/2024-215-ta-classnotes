
.globl NewtonMethod
# changellange!
# try use Newton's method to find root.
# @args: a0 - (float) initial guess.
# 	 a1 - pointer to a function: float->float
# 	 a2 - (float) the h value to use (for differentiation)
#        a3 - (int) number of iter to do
# @ret:  a0 - (float) the root 
NewtonMethod:
