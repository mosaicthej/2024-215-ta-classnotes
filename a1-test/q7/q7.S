.equ SYS_printInt, 244
.equ SYS_readInt,  245
.equ SYS_printStr, 248
.equ SYS_readStr,  249
.equ SYS_readChar, 247
.equ SYS_exit,     93

.equ NL, 10 # '\n'
.equ MAXLN, 40 # 40 chars
.equ MAXBUF, 41 # with '\0'

.section .rodata
str_pr: .string "\n\nEnter a string: "
chr_pr: .string "Enter a character: "

output: .string "\nLetter's occurance is: "

.section .data
buffer: .space MAXBUF

.section .text

.globl _start
# the `main` program that used to test the chrFreq function
# in a loop, prompt for input of string and chr.
# check the chr, if it's NL, exit, otherwise calls the function
# then display the result
_start:
li  s0, NL  # newLine.

main_loop:
  la  a0, str_pr
  li  a7, SYS_printStr
  ecall # print("Enter a string\n")

  la  a0, buffer
  li  a1, MAXLN
  li  a7, SYS_readStr
  ecall # scanf(%s)...
  # upon trap back... buffer will contain the user input string.

  la  a0, chr_pr
  li  a7, SYS_printStr
  ecall # print("Enter a char\n")

  li  a7, SYS_readChar
  ecall # scanf("%s", ($a0))

  # a0 will be the char that is read...
  # this is bad... as it breaks the structure...
  # for now just keep it here... I'll think a way to refactor.
    beq   a0, s0, done_main   # in case char is newline

  mv  a1, a0      # set arg2
  la  a0, buffer  # set arg1
  call  chrFreq   

  # result in a0. Display the output.
  mv  t0, a0 # save it in t0 for now.
  la  a0, output
  li  a7, SYS_printStr
  ecall
  mv  a0, t0
  li  a7, SYS_printInt
  ecall
  # print the result.
  j   main_loop


done_main:
  mv  a0, zero
  li  a7, SYS_exit
  ecall   # exit(0)





### func ###
# func: chrFreq
#   find the frequency of the chr in string.
# @arg: a0: address to the string to be read.
# @arg: a1: the char to find.
# @ret: a0: frequency of the char in the string.
#
# register usage:
# t0: holding the address of the current chr to be examine
# t1: the character's value.
### endFunc ###
.local chrFreq
chrFreq:
# go throught the character array,
# check if there is a occurance.
# end when encounter null chr.
  mv  t0, a0
  mv  a0, zero  # count=0;

  # this is like the do_while loop way... So saves 1 branch instruction.
  # Branches are bad because they fucks up the pipeline 
  # and prefecting and cache.
    lbu   t1, 0(t0)
    beqz  t0, chrFreq_end
  chrFreq_chr_loop:
  # get the character from str (t1 <- chr)
    bne   t1, a1, chrFreqNextChr   # skip increment count 
      addi  a0, a0, 1   # inc the count
    chrFreqNextChr:
    addi  t0, t0, 1 # next chr's loc
    lbu   t1, 0(t0) # chr's value
    bnez  t1, chrFreq_chr_loop # if t1 is not NUL, keep going.

  chrFreq_end:
  ret   # done


