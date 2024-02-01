.section .text

.globl _start
_start:
sw t0, 0(t1)
beq t1, t2, match
lui t1, 100000 #in hex would be 0x 01 86A0
jal zero, done
match: xor t0, t0, t0
done:  addi t3, t1, 10

