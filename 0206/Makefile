TOOLCHAINPATH?=/usr/local/riscvmulti/bin/
PREF=riscv64-unknown-elf-
XPREF=$(TOOLCHAINPATH)$(PREF)
AS=as
LD=ld

XAS=$(XPREF)$(AS)
XLD=$(XPREF)$(LD)

ASFLAGS32=-march=rv32i -mabi=ilp32
FLAGS64=-march=rv64gc -mabi=lp64d

LDFLAGS32=-m elf32lriscv --no-relax
LDFLAGS64=-m elf64lriscv --no-relax

binaries=run_fib

.PHONY: all clean
	
all: $(binaries)

run_fib: fib.o run_fib.o 
	$(XLD) -o $@ $? $(LDFLAGS32)

run_fib.o: ./run_fib.S
	$(XAS) -o $@ $? $(ASFLAGS32)

fib.o: ./fib.S
	$(XAS) -o $@ $? $(ASFLAGS32)

clean:
	*.o $(binaries)
