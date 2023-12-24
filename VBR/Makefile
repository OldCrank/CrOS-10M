## Craig 23-7-2023. My testing makefile for C samples.
## Craig 3-11-2023. CrOS-05; adjust this makefile for just VBR.


VBR: CrOS-VBR.bin

CrOS-VBR.bin: CrOS-VBR.o
	i386-elf-ld -Ttext 0x7c00 --oformat binary -Map=CrOS-VBR.map -o CrOS-VBR.bin CrOS-VBR.o

CrOS-VBR.o: CrOS-VBR.s mydisk.s my32bit_print.s mygdt.s myswitch_pm.s
	i386-elf-as CrOS-VBR.s -o CrOS-VBR.o 

####    #####    ####


clean:
	rm -rf *.bin
	rm -rf *.o 


