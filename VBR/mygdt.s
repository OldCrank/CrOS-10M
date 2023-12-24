## Craig 25-08-2023. My conversion of gdt.asm

gdt_start: # don't remove the labels, they're needed to compute sizes and jumps
    #; the GDT starts with a null 8-byte
    .long 0x00000000 #; 4 byte
    .long 0x00000000 #; 4 byte

#; GDT for code segment. base = 0x00000000, length = 0xfffff
#; for flags, refer to os-dev.pdf document, page 36
gdt_code: 
    .word 0xffff    #; segment length, bits 0-15
    .word 0x0       #; segment base, bits 0-15
    .byte 0x0       #; segment base, bits 16-23
    .byte 0b10011010 #; flags (8 bits)
    .byte 0b11001111 #; flags (4 bits) + segment length, bits 16-19
    .byte 0x0       #; segment base, bits 24-31

#; GDT for data segment. base and length identical to code segment
#; some flags changed, again, refer to os-dev.pdf
gdt_data:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x0

gdt_end:

#; GDT descriptor
gdt_descriptor:
    .word gdt_end - gdt_start - 1 #; size (16 bit), always one less of its true size
    .long gdt_start #; address (32 bit)

#; define some constants for later use
##CODE_SEG: .equ (gdt_code - gdt_start)
##DATA_SEG: .equ (gdt_data - gdt_start)
    .equ CODE_SEG, gdt_code - gdt_start
    .equ DATA_SEG, gdt_data - gdt_start
