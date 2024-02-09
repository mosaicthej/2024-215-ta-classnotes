.equ SYS_exit,      93
.equ SYS_printInt,  244
.equ SYS_readInt,   245
.equ SYS_printChar, 246
.equ SYS_readChar,  247
.equ SYS_printStr,  248
.equ SYS_readStr,   249

.section .rodata
prompt: .string "\nEnter a num"

.section .text
.globl _start

# in a loop, print prompt,
# then read the input as int (assume already an int)
# (good practice is to check the return value)
# if input a negative num, exit

_start:
  # puts("\nEnter a num:")
  la    a0, prompt
  li    a7, SYS_printStr
  ecall

  # int k; scanf("%d", &k);
  li    a7, SYS_readInt
  ecall

  bltz  a0, done
  
  # if we got here, that means it's a positive int input
  # so calculate the fib and print
  # can call directly since input k already in a0(param)
  call Fib
  # now Fib(k) is in a0
  li    a7, SYS_printInt
  ecall # printf("%d", Fib(k));
  j     _start # go back.

done:
  li a7, SYS_exit
  ecall
