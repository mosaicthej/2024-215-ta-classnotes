toolchainpref=riscv64-unknown-elf-
AS=$(toolchainpref)as
LD=$(toolchainpref)ld

qemubin=/opt/qemu215/bin/qemu-riscv32

ASFLAG=-march=rv32i -mabi=ilp32
LDFLAG=-m elf32lriscv --no-relax

binaries=q7

.PHONY: all clean qemu qemu-gdb

all: $(binaries)

q7: q7.o
	$(LD) $(LDFLAG) -o $@ $<

q7.o: q7.S
	$(AS) $(ASFLAG) -g -o $@ $<

qemu: q7
	$(qemubin) $<

qemu-gdb: q7
	@echo "remote target at localhost:1234"
	$(qemubin) -g 1234 $<

clean:
	rm $(binaries) *.o
