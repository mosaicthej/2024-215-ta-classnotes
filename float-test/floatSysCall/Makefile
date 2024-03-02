TOOLCHAIN=/usr/local/riscvmulti/bin/riscv64-unknown-elf-
CC=gcc
AS=as
LD=ld
DB=gdb

XCC=$(TOOLCHAIN)$(CC)
XAS=$(TOOLCHAIN)$(AS)
XLD=$(TOOLCHAIN)$(LD)
XGDB=$(TOOLCHAIN)$(DB)

ASFLAGS=-march=rv32if_zfa -mabi=ilp32
LDFLAGS=-melf32lriscv --no-relax

binaries= floatSysTest

QEMUPATH=/student/cmpt215/bin/qemu215-floatio/bin/qemu-riscv32

.PHONY: all clean qemu

all: $(binaries)

floatSysTest: floatSysTest.o
	$(XLD) $(LDFLAGS) $< -o $@

floatSysTest.o: floatSysTest.S
	$(XAS) $(ASFLAGS) $< -o $@ -g

clean:
	rm -f $(binaries) *.o

qemu: floatSysTest
	$(QEMUPATH) $<


qemu-gdb: floatSysTest
	echo "port 1234"
	$(QEMUPATH) -g 1234 $<

gdb: floatSysTest
	echo "make sure qemu is on debuging mode"
	$(XGDB) $<
