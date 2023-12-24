## Craig 1-7-2023. Start MBR-03 file.
## Craig 7-7-2023. trying to get copy lower section working.
## Craig 12-7-2023. Seems to be working. Looked like it was loading VBR (1 sector).
## Start new folder and try to load whole kernel image. Use CrOS as image.
## Craig 19-8-2023. Copied MBR-04 from CrOSEX4, and renamed to MBR-05.
##                  I had different versions of MBR-04.


.section .text
.code16
//.= $0x7c00             #; This is also set in linker script linkd.ld
                       #;   not sure which take priority.
.global _start

_start: 

  cli                           ##; We do not want to be interrupted
  xor %ax, %ax                  ##; 0 AX
  mov %ax, %ds                  ##; Set Data Segment to 0
  mov %ax, %es                  ##; Set Extra Segment to 0
  mov %ax, %ss                  #; Set Stack Segment to 0
  mov $0x7c00, %sp                  #; Set Stack Pointer to 0

### Copy Lower code should be here, but I've left out for now.
  CopyLower:
    mov $0x0100, %cx            #; 256 WORDs in MBR.  = 512 bytes.
    mov $0x7c00, %si            #; Current MBR Address
    mov $0x0600, %di            #; New MBR Address
    cld                         #; lets ensure direction flag is clear
    rep movsw                 #; Copy MBR
//  jmp 0:LowStart              #; Jump to new Address
//  jmp $0, $0x0612              #; Jump to new Address. Hardcoded address
  jmp $0, $LowStart              #; try non hardcode version.
//    push %ax
//    push 

 
 
LowStart:
  sti                           #; Start interrupts
  cld                     #; Clear direction flag.

### xchg %bx, %bx      ## Magic Break point for Bochs

  movb %dl, bootDrive   #; Save BootDrive set by BIOS

### xchg %bx, %bx      ## Magic Break point for Bochs

///## Working MBR msg print
///  mov $MSG_MBR, %si    #; start of msg
///  //mov $0, %si
///  mov $0x0e, %ah
///Loop1:
///  lodsb
///  //mov (%si), %al
///  or %al, %al         # dont know why this
///  cmp $0x0, %al
///  jz finis 
///  int $0x10
///  jmp Loop1 
///finis:  

  mov $MSG_MBR, %si    #; start of msg "\nMessage from MBR!\n\r"
  call myprint

//  mov $0xCAFE, %ax        # place the number 0xCAFE
//  cli
//  hlt

/*
// This print char section is working.
Print_Char:
  xor %ecx, %ecx
  movb $0x08, %cl
loop2:
  movb $0x66, %al       #; char to print.  0x66 = 'f'.
  movb $0x0e, %ah       #; int 10h sub function
  int $0x10
  dec %cl               #; dec automatically sets zero flag.
  jnz loop2
*/

//done:
//  mov $0xCAFE, %ax        # place the number 0xCAFEBABE in the register eax

///MSG2:
///## Working MBR msg print
///  mov $MSG_MBR2, %si    #; start of msg
///  //mov $0, %si
///  mov $0x0e, %ah
///Loop2:
///  lodsb
///  //mov (%si), %al
///  or %al, %al         # dont know why this
///  cmp $0x0, %al
///  jz finis2 
///  int $0x10
///  jmp Loop2 
///finis2:  
///msgdone:


  mov $MSG_MBR2, %si    #; start of msg Type some junk and hit ENTER..
  call myprint

//  mov $0xBADF, %ax

  xor %al, %al
getkey:
  xor %ah, %ah          #; Read char sub function.
  int $0x16            ## Call bios interrupt.
  cmp $0x0D, %al        #; RETURN char.
  je next2
//  movb $0x64, %al       #; char to print
  movb $0x0e, %ah       #; int 10h sub function
  int $0x10
  jmp getkey

next2:  
  movb $0x0A, %al       #; char to print.  0A = linefeed.
  movb $0x0e, %ah       #; int 10h sub function
  int $0x10
  movb $0x0D, %al       #; char to print. Carriage Return.
  movb $0x0e, %ah       #; int 10h sub function
  int $0x10
//  movb $0x62, %al       #; char to print 'b'.
//  movb $0x0e, %ah       #; int 10h sub function
//  int $0x10


  movw $0xBADF, %ax
//  movw $MSG_MBR, %si
//  mov $MSG_MBR(%rip), %di 
//  mov $LowStart, %di 
//  sub $0x1000, %di

//  nop
  mov $MSG_LOADING, %si    #; start of loading msg
  call myprint

ReadVBR:
  mov $PT1, %ebx            #; Point to active Partition table.
  mov $0x7c00, %di          #; Loading VBR to 0x7c00 (dec 31,744)
  mov $1, %cx               #; only 1 sector
  call ReadSectors

JumpToVBR:
  cmpw $0xAA55, (0x7DFE)    #; Check Boot Signature. 0x7dfe = 32,254
  jne ERROR                 #; Error if not Boot Signature
  mov $PT1, %si            #; Set DS:SI to Partition Table Entry
  movb bootDrive, %dl      #; Set DL to Drive Number
  ljmp $0x0, $0x7C00                #; Jump To VBR

  jmp .                     #; we shouldn't get here, just loop
### ENDS HERE ###

myprint:
## Working MBR msg print
  //mov $MSG_MBR2, %si    #; start of msg. 
  //mov $0, %si
  #; %si to be set before call to sub.routine
  mov $0x0e, %ah
myprtLp1:
  lodsb
  //mov (%si), %al
  or %al, %al         # dont know why this
  cmp $0x0, %al
  jz myprtEnd 
  int $0x10
  jmp myprtLp1
myprtEnd:  
  ret

ReadSectors:
  cld
  movb bootDrive, %dl
  movb $0x2, %ah            #; int13h function 2 read.
  movb $1, %al              #; number of sectors to read in al.
  #; I want to load the first sector of the first partition.
  #;   LBA sector = 17.  Cyl = 0, Head = 1, Sector = 1.
  movb $0x0, %ch            #; Cylinder 0.
  movb $0x01, %cl           #; Sector 33,  Hex 0x21.         
  movb $0x01, %dh           #; Head 32,  Hex 0x20.
  mov $0x7c00, %bx          #; Load to address
  int $0x13
  ret

DriveStatus:
  movb $0x01, %ah           #; Function get last drive status.
  movb bootDrive, %dl
  int $0x13
  ret

ERROR:
  mov $MSG_ERROR, %si    #; start of loading msg
  call myprint
  jmp .                   #; Error, so just stop.


bootDrive: .byte 0          #; our drive number variable.

MSG_MBR:
    .asciz "\nMessage from MBR!\n\r"
MSG_MBR2:
    .asciz "Type some junk and hit ENTER..\n\r"
MSG_LOADING:
    .asciz "\n\nLoading CrOS from disk..\n\r"
MSG_ERROR:
    .asciz "\n\nERROR! VBR signature?..\n\r"
 
.Padding:
###.set PadSize, ($0x1b4 - .Padding)
###.fill ($0x1b4 - ($-$$)), 1, 0      #; Pad For MBR Partition Table
###.fill $PadSize, 1, 0      #; Pad For MBR Partition Table
.fill 436-( . - _start ), 1, 0      #; Pad For MBR Partition Table
###.fill 510-( . - _start ), 1, 0      #; Pad 


UID: .fill 10, 1, 0           #  ; Unique Disk ID
####PT1: .fill 16, 1, 0               #; First Partition Entry
PT1:
  .byte 0x80                    # is bootable? 0x80 = bootable. 0x00 = non bootable.
  ## next three byte are CHS starting values. Refer notes about bits used.
  ## This is usually within the first 1024 cylinders of disk. If beyond, 
  ## then maybe set to maximum values of: 1023, 254, 63; equals: FE FF FF on disk.
  .word 0x0101                  # note words are written in reverse order.
  .byte 0x00  
  ## System type.  0x0C = 32 FAT 32 LBA, plus many other possibilities. Refer documentation.  
  .byte 0x01 
  ## next three byte are CHS ending values. Refer notes about bits used.
  .word 0x5103
  .byte 0x2d
  ## Next four bytes = starting sector.
  .word 0x0011
  .word 0x0000
  ## Next for bytes = partition size in blocks (512 bytes each).
  .word 0x4ff4
  .word 0x0000
PT2: .fill 16, 1, 0               #; Second Partition Entry
PT3: .fill 16, 1, 0               #; Third Partition Entry
PT4: .fill 16, 1, 0               #; Fourth Partition Entry


 
.word 0xAA55                     #; Boot Signature

