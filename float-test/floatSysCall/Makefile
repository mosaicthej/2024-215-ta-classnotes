TOOLCHAIN=/usr/local/riscvmulti/bin/riscv64-unknown-elf-
CC=gcc
AS=as
LD=ld

XCC=$(TOOLCHAIN)$(CC)
XAS=$(TOOLCHAIN)$(AS)
XLD=$(TOOLCHAIN)$(LD)

ASFLAGS=-march=rv32if -mabi=ilp32
LDFLAGS=-melf32lriscv --no-relax

binaries= floatSysTest

QEMUPATH=/student/cmpt215/bin/qemu215-floatio/bin/qemu-riscv32

.PHONY: all clean qemu

all: $(binaries)

floatSysTest: floatSysTest.o
	$(XLD) $(LDFLAGS) $< -o $@

floatSysTest.o: floatSysTest.S
	$(XAS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(binaries) *.o

qemu: floatSysTest
	$(QEMUPATH) $<


