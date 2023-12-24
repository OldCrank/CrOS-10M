## Makefile for kernel.bin.
## I know this is not a very efficient way to use a makefile.

## Craig 1-7-2023. My testing makefile.
##    Original file is Makefile.org
## Craig 13-7-2023. New version to try making both my MBR and os-image.bin
## Craig 3-11-2023  This file now in ~/Documents/Projects/OS-Dev/CrOS-05/CrOS
##    Trying to eliminate .asm files, and streamline.

####  commenting out most using #### until see if still works.

# ASM_SOURCES = $(wildcard boot/*.s kernel/*.s)
ASM_SOURCES = $(wildcard kernel/*.s)
C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c libc/*.c usrcmds/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h libc/*.h usrcmds/*.h)
# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o} 

# Change this if your cross-compiler is somewhere else
CC = /usr/local/i386elfgcc/bin/i386-elf-gcc
## CC = gcc
GDB = /usr/local/i386elfgcc/bin/i386-elf-gdb
# -g: Use debugging symbols in gcc
CFLAGS = -g -ffreestanding -Wall -Wextra -fno-exceptions -m32 -v

## First rule is run by default
## This rule is not used in CrOS project.
## It is used when making a bootable floppy image.
#os-image.bin: boot/bootsect.bin kernel.bin
#	cat $^ > os-image.bin

# '--oformat binary' deletes all symbols as a collateral, so we don't need
# to 'strip' them manually on this case
kernel.bin: kernel/kernel_entry.o ${OBJ} $(ASM_SOURCES:.s=.o)
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary


# Generic rules for wildcards
# To make an object, always compile from its .c
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@


%.o: $.s
	i386-elf-as -c $< -o $@	


clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o libc/*.o
