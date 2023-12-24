## Craig 1-7-2023. My testing makefile.
##    Original file is Makefile.org
## Craig 13-7-2023. New version to try making both my MBR and os-image.bin
## Craig 3-11-2023. CrOS-05; adjust this makefile for just MBR.



MBR: CrOS-MBR.bin

CrOS-MBR.o: CrOS-MBR.s
	i386-elf-as -c $< -o $@

CrOS-MBR.bin: CrOS-MBR.o  
	i386-elf-ld -o $@ -Ttext 0x0600 $^ --oformat binary


clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o libc/*.o
