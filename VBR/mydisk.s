## load 'dh' sectors from drive 'dl' into ES:BX
##  BX set by calling program.
## [Craig 13-7-2023] I need to modify this to load from 1st partition
##     instead of floppy, needs different CHS info.
## Craig 25-08-2023. Copied this from disk.asm. I need to convert to 
##     AT&T syntax.

disk_load:
    ## TMP return msg
    ##mov $LOAD_START, %si
    ##call printMSG
    ###pusha
    # reading from disk requires setting specific values in all registers
    # so we will overwrite our input parameters from 'dx'. Let's save it
    # to the stack for later use.
    pushw %dx

    cld

#  ##### going to hard code values in for test
#    movb $0x2, %ah # ah <- int 0x13 function. 0x02 = 'read'
#    movb %dh, %al   # al <- number of sectors to read (0x01 .. 0x80)
#                 #   dh set from bootsect.asm
#    #; I want to load the third sector of the first partition.
#  #;   LBA sector = 2050.  Cyl = 0, Head = 32, Sector = 35.
#    movb $0x23, %cl ##; Sector 35,  Hex 0x23.
#                 # 0x01 is our boot sector, 0x02 is the first 'available' sector
#    movb $0x00, %ch # ch <- cylinder (0x0 .. 0x3FF, upper 2 bits in 'cl')
#    # dl <- drive number. Our caller sets it as a parameter and gets it from BIOS
#    # (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
#    movb $0x20, %dh # dh <- head number (0x0 .. 0xF)

#    # [es:bx] <- pointer to buffer where the data will be stored
#    # caller sets it up for us, and it is actually the standard location for int 13h

  movb bootDrive, %dl
  ### movb $0x80, %dl
##  xchg %bx, %bx      ## Magic Break point for Bochs
  # (0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2)
  movb $0x2, %ah        ## :0x7c9e    #; int13h function 2 read.
  ##movb $1, %al              #; number of sectors to read in al.
  movb %dh, %al
  #; I want to load the first sector of the first partition.
  #;   LBA sector = 2050.  Cyl = 0, Head = 32, Sector = 35.
  movb $0x00, %ch            #; Cylinder 0.
  movb $0x03, %cl           #; Sector 33,  Hex 0x21.         
  movb $0x01, %dh           #; Head 32,  Hex 0x20.
  mov $0x1000, %bx          #; Load to address


    int $0x13      # BIOS interrupt
    jc disk_error # if error (stored in the carry bit)

    popw %dx         # restore dx so we have dh restored for cmp.
    ###mov %dx, %dh    ######  tmp
    ###mov %dh, %al    ######  tmp
    cmp %dh, %al    # BIOS also sets 'al' to the # of sectors read. Compare it.
    jne sectors_error

    ## TMP return msg
    mov $LOAD_END, %si
    call printMSG

    ###popa

    ret

 
disk_error:
    mov $DISK_ERROR, %si
    call printMSG
    ##call print_nl
    ##mov %ah, %dh # ah = error code, dl = disk drive that dropped the error
    ##call print_hex # check out the code at http://stanislavs.org/helppc/int_13-1.html
    jmp disk_loop

sectors_error:
    mov $SECTORS_ERROR, %si
    call printMSG

disk_loop:
    mov $LOOPING, %si
    call printMSG    # just keep printing last error msg.
    ##ret
    jmp disk_loop

DISK_ERROR: .asciz "\nDisk read error\n\r"    ## : 0x7cd2
SECTORS_ERROR: .asciz "\nIncorrect number of sectors read\n\r"
##LOAD_START: .asciz "\nLOAD starting.\n\r"
LOAD_END: .asciz "\nNo Error. Returning.\n\r"
LOOPING: .asciz "\nLOOPING!!!.\n\r"
