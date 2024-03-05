TOOLCHAIN=/usr/local/riscvmulti/bin/riscv64-unknown-elf-
CC=gcc
AS=as
LD=ld
DB=gdb

XCC=$(TOOLCHAIN)$(CC)
XAS=$(TOOLCHAIN)$(AS)
XLD=$(TOOLCHAIN)$(LD)
XGDB=$(TOOLCHAIN)$(DB)

ASFLAGS=-march=rv32imf_zfa -mabi=ilp32
LDFLAGS=-melf32lriscv --no-relax

QEMUPATH=/student/cmpt215/qemu/bin/qemu-riscv32

.PHONY: all clean qemu

all: euler_main testFact

euler_main: fact.o euler.o euler_main.o
	$(XLD) $(LDFLAGS) -o $@ $?

euler.o: euler.S
	$(XAS) $(ASFLAGS) -o $@ -g $<

euler_main.o: euler_main.S
	$(XAS) $(ASFLAGS) -o $@ -g $<

fact.o: fact.S
	$(XAS) $(ASFLAGS) -o $@ -g $<

# since our abi is conformant,
# we can direct compile from c file
# comment above target and uncomment below
# to get 
#fact.o: fact.c
#	$(XCC) $(ASFLAGS) -c -o $@ -g $<


testFact: fact.o testFact.o
	$(XLD) $(LDFLAGS) -o $@ $?

testFact.o: testFact.S
	$(XAS) $(ASFLAGS) -g -o $@ $<

qemu: euler_main
	@$(QEMUPATH) $<

qemu-gdb: euler_main
	$(QEMUPATH) -g 1234 $<
	@echo 1234

gdb: euler_main
	$(XGDB) $<

clean:
	rm -f *.o euler_main
