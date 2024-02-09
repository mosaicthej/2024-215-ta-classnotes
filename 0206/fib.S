
.section .text

# computes fib
# calls other functions, so save ra.
# this example uses fp.
# also need two more regs so the intermediate result
# (one of the fibs) and initial arg (x) need to be saved
# @arg:
#   a0 : x, input for fib
# @ret:
#   a0:  result of calculating fib(x)
#     which is fib(x-1) + fibx(x-2)
# what goes into the frame? (symbol-table ish thing:)
# 
# |    var   |            desc      | location (FP-relative) |
# |----------|----------------------|------------------------|
# |    x     |    passed in param   | -4(FP)
# | fib(x-1) | first recursive calc | -8(FP)
#
.globl Fib
Fib:
addi  sp, sp, -8
sw    ra, 4(sp)
sw    fp, 0(sp)
mv    fp, sp  # from now on, use sp for making more space, fp for ref
  # first, take care about the base case.
  li  t0, 2
  blt a0, t0, Fib_base
  # if get to this line, it's not a base case
  Fib_nonBase:
    # return fib(x-1) + fib(x-2)
    # i need to preserve initial x <- a0
    addi  sp, sp, -4
    sw    a0, -4(fp)  # x will ALWAYS has the offset of -4
    # now call fib(x-1)
    #   1. prepare arg: x-1 -> a0
    addi  a0, a0, -1
    #   2. call fib(a0)
    call  Fib
    # at this point, Fib has returned
    # and a0 will have the value of fib(x-1)
    # want to keep this thing
    addi  sp, sp, -4
    sw    a0, -8(fp)
    # then wants to do fib(x-2)
    # 0. first restore the input x
    lw    a0, -4(fp) # this is x's location
    # 1. prepare arg of x-2
    addi  a0, a0, -2
    # 2. call Fib with prepared args
    call  Fib
    # at this point, a0 has the value of Fib(x-2)
    # wants to return Fib(x-1)+Fib(x-2)
    lw    t0, -8(fp) # t0 <- Fib(x-1)
    add   a0, a0, t0 # a0 <- Fib(x-1) + Fib(x-2)
    # things are done, now wants to return
  # j     Fib_done
    addi  sp, sp, 8   # restore stack
    # this sp will be the same as in line 15, 16, 17
  Fib_base:
    # nothing to be done, just return whatever in a0
Fib_done:
lw    fp, 0(sp)
lw    ra, 4(sp)
addi  sp, sp, 8
ret
    


