## Craig 27-07-2023. Start myVBR-01.s file.
## Try replicate DOS32 vbr first 2 sectors.
##  MBR leaves bootDrive info in dl register.

.section .text 
.code16

.set KERNEL_OFFSET, 0x1000

.global _start
.global bootDrive
_start: 

    jmp VBRcode
    nop                   ## maybe required by some BIOS

DosVer:       .ascii "MSDOS5.0"  

BiosParamBlock:
BPS:          .word 0x0200   ## Bytes Per Sector  0x0200 =512  
SPC:          .byte 0x08     ## Sectors Per Cluster 0x08 = 8
ResSects:     .word 0x0001   ## Reserved Sectors 0x0C01 = 1
NumFats:      .byte 0x02     ## Number of Fats
RtDirEntries: .word 0x0200    ## Root Dir Entries
TotLogSects:  .word 0x5027    ## Total Logical Sectors: = 20,519
MediaDesc:    .byte 0xF8      ## Media descriptor = disk
SectsPerFat:  .word 0x000b    ## Logical sectors per FAT = 11
PhysSectsTrk: .word 0x0011    ## Physical Sectors per Track 0x0011 = 17
NumHeads:     .word 0x0004    ## Number of Heads = 4
HidSects:     .long 0x00000011  ## Hidden Sectors = 17
LTLS:         .long 0x00000000  ## Large Total Logical Sectors

DrvNum:       .byte 0x80        ## Physical drive number
Flags:        .byte 0x00        ## Flags etc.
ExSig:        .byte 0x29        ## Extended boot signature
VolSerial:    .long 0x00000000  ## Volume Serial Number
VolLabel:     .ascii "CrDOS      " ## Volume label (11 bytes).
FileSys:      .ascii "FAT12   "   ## File System type (8 bytes).

####  My VBR code starts here ####

## Define Data and Procedures here
##  Nope! Putting too much code in here seems to stop DOS recognition.

### MSG_1:  .asciz "\nMVBR1-01-3 msg\n\r"

##  .include "mydisk.s"
##  .include "mygdt.s"
##  .include "my32bit_print.s"  ## This may need to be put after 32 bit switch.

###   ###   ###   ######  ######  ######  ######  

VBRcode:

## MSG_VBR:
##    .asciz "Message from VBR1-1 REAL mode!\n"

###  START OF DOS COPY VERSION ###
  xor %cx, %cx
  mov %cx, %ss          ## always set %ss then %sp together
  mov $0x7bf4, %sp      ## and in this order.
  mov %cx, %es 
  mov %cx, %ds
  mov $0x7c00, %ebp     ## :0x7c49
  mov %cl, 0x2(%bp) 

## Store bootDrive
##   moved store boot drive ahead of check int13 extensions
##   as dl gets altered there!

## xchg %bx, %bx      ## Magic Break point for Bochs

  movb %dl, bootDrive

  

  ## Check for INT13 Extensions
  mov 0x40(%bp), %dl 
  mov $0x41, %ah        ## :0x7c85
  mov $0x55aa, %bx 
  int $0x13 


## xchg %bx, %bx      ## Magic Break point for Bochs  

  ## Display char 'a'
  mov $0, %bh    ## set display page
  mov $'a', %al  ## 'a' = 0x61
  mov $0x0e, %ah 
  int $0x10

  


## Display message
  mov $MSG_1, %si      ## "\nMyVBR\n\r"
  call printMSG

load_kernel:
  mov $MSG_LoadKernel, %si      ## "\nLoading.\n\r"
  call printMSG

  mov KERNEL_OFFSET, %bx
  mov $32, %dh   #; Number of sectors to load. Was $31 but tmp to 2
  mov bootDrive, %dl
  call disk_load      #; loads kernel
##  call switch_to_pm   #; 

## attempt to confirm kernal loaded.
##movb 0x1000, %al           #load first word into %ax
##movb $'k', %al           #load first word into %ax
##movb %al, 0xb80ba       # colour $2F + chars 'O' + 'K'
##movw $0x2f4b, 0xb80ca    ### This is NOT working in Real mode!

#### Display 1st Kernel byte 
##  mov $0, %bh    ## set display page
##  mov $0xe8, %al
##  mov $0x0e, %ah 
##  int $0x10
## Display 1st Kernel byte 
  mov $0, %bh    ## set display page
  ##mov 0x1000, %al
  mov $'L', %al
  mov $0x0e, %ah 
  int $0x10

## Display 1st Kernel byte 
  mov $0, %bh    ## set display page
  mov 0x1000, %al
  ##mov $'L', %al
  mov $0x0e, %ah 
  int $0x10

## xchg %bx, %bx      ## Magic Break point for Bochs

#### movl $0x2f4b2f4f, 0xb80aa       # colour $2F + chars 'O' + 'K'

  call switch_to_pm   #;

#### .include "myswitch_pm.s"

## Display 1st Kernel byte 
   ### HEY! This bit probably wont work once in Protected Mode!
   ###  so don't really expect to see this!
  mov $0, %bh    ## set display page
  ##mov 0x1000, %al
  mov $'Z', %al
  mov $0x0e, %ah 
  int $0x10

_myloop:
  nop
  jmp _myloop

##  cli
##  hlt       ## Halting the processor seems to turn monitor off.

###### END OF MAIN CODE ######


###### Define other procedures here ######
  .include "mydisk.s"
  .include "mygdt.s"
  .include "my32bit_print.s"
  .include "myswitch_pm.s"

### printMSG new version2 ###
.type printMSG, @function
printMSG:
##  Called with %si set to message.

##  mov $MSG_1, %si    #; start of msg
  mov $0x0e, %ah
Loop1:
  lodsb
  cmp $0x0, %al
  je finis 
  int $0x10
  jmp Loop1 
  
finis:  
  ret

### START 32 BIT CODE ###
.code32
BEGIN_PM:
  mov $MSG_PROT_MODE, %ebx
  call print_string_pm
###  call KERNEL_OFFSET           #; Give control to the kernel
call KERNEL_OFFSET
1: jmp 1b

##MSG_1:  .asciz "\nMyVBR1-01-6 in REAL mode.\n\r"
##MSG_LoadKernel: .asciz "\nLoading CrOS kernel..\n\r"
##MSG_PROT_MODE:  .asciz "Landed in 32-bit Protected Mode"

### I was going over 512 bytes, so reduced msgs.
MSG_1:  .asciz "\nMyVBR\n\r"
MSG_LoadKernel: .asciz "\nLoading.\n\r"
MSG_PROT_MODE:  .asciz "32-bit"

bootDrive: .byte 0                  #; Our Drive Number Variable
PToff: .word 0                      #; Our Partition Table Entry Offset
 
##times (0x1b4 - ($-$$)) nop      #; Pad For MBR Partition Table
.Padding:
.fill 510-( . - _start ), 1, 0      #; Pad For MBR Partition Table




.word 0xAA55                     #; Boot Signature


####  I don't know if Sector2 is required but anyway ####
####  Some hardware BIOSes seems to need this??      ####
Sector2:
  .byte 0x52
  .byte 0x52
  .byte 0x61 
  .byte 0x41 
  .fill 996-( . - _start ), 1, 0      #; Pad For MBR Partition Table
  .byte 0x72
  .byte 0x72
  .byte 0x41 
  .byte 0x61 
  .byte 0x7F 
  .byte 0xE2 
  .byte 0x01C 
  .byte 0x00 
  .byte 0x03 
  .fill 1022-( . - _start ), 1, 0
  .word 0xAA55
