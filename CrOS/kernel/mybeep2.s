### And here is the beeping code in GNU asm:

### This code wont work immediately in userspace program, 
### because kernel forbids writing into IO ports. 
### In order to allow that the code also requires ioperm call: ioperm(0x42, 32, 1) 
### and running with sudo. See the full working example in this gist.
### https://gist.github.com/eprigorodov/59de9d1eadf2b03174c4c2ef705ad6d3

### CL - compile with: i386-elf-as beeping_GNU-asm.s -o beeping_GNU-asm.o
###         Link with: ld -o beeping_GNU-asm beeping_GNU-asm.o

## compile: gcc -o beep.o -c beep.s ; ld -o beep beep.o
## run: sudo ./beep, non-root userspace code is not allowed to use port IO

    .global mybeep2
    ##.text

mybeep2:
    ## dont need ioperm() anymore because not in Linux. ##
    ##### ioperm(0x42, 32, 1)
    ###mov     $101, %eax  # ioperm() == 173 in x86_64
    ###mov     $0x42, %ebx # from port 0x42
    ###mov     $32, %ecx   # num ports, to port 0x62
    ###mov     $1, %edx    # enable
    ###///syscall
    ###int $0x80
    ###cmpl    $0, %eax
    ###je      IO_OK

    ##### ioperm() returned error,
    ##### write(1, message, 13)
    ###mov     $4, %eax    # write() == system call 4 in 32 bit.
    ###mov     $1, %ebx    # stdout
    ###mov     $message, %ecx
    ###mov     $37, %edx   # message length
    ###///syscall
    ###int $0x80
    ###mov     $1, %ebx    # set retcode 1
    ###jmp     _exit

    ## Craig - add store regs.
    pusha

    ## send "set tune" command
IO_OK:
    movb    $0xB6, %al
    outb    %al, $0x43

    ## nanosleep to let the IO complete                                                                                                                                  
    movl    $0x1000, %eax
1:  subl    $1, %eax
    cmpl    $0, %eax
    jne     1b

    ### First tone ###

    ## set 220Hz, 0x152F == 1193180 / 220
    ## set 700Hz, 0x06A8 == 1193180 / 700
    ## set 1335Hz, 0x037E == 1193180 / 220
    movb    $0x7E, %al 		## set frequency low byte
    outb    %al, $0x42

    ## nanosleep to let the IO complete
    movl    $0x1000, %eax
1:  subl    $1, %eax
    cmpl    $0, %eax
    jne     1b

    movb    $0x03, %al 		## set frequency high byte
    outb    %al, $0x42

    ## nanosleep to let the IO complete
    movl    $0x1000, %eax
1:  subl    $1, %eax
    cmpl    $0, %eax
    jne     1b

    ## turn on the speaker
    inb     $0x61, %al
    movb    %al, %ah
    orb     $0x3, %al
    outb    %al, $0x61

    ## sleep about 1 sec
    ###movl    $0x30000000, %eax
    movl    $0x20000000, %eax
1:  subl    $1, %eax
    cmpl    $0, %eax
    jne     1b

    ## turn off the speaker
    movb    %ah, %al
    andb    $0xfc, %al
    outb    %al, $0x61

    ### Second tone ###

    ## set 220Hz, 0x152F == 1193180 / 220
    ## set 700Hz, 0x06A8 == 1193180 / 700
    ## set 1335Hz, 0x037E == 1193180 / 220
    ## set 916Hz, 0x0516 == 1193180 / 916
    movb    $0x16, %al 		## set frequency low byte
    outb    %al, $0x42

    ## nanosleep to let the IO complete
    movl    $0x1000, %eax
1:  subl    $1, %eax
    cmpl    $0, %eax
    jne     1b

    movb    $0x05, %al 		## set frequency high byte
    outb    %al, $0x42

    ## nanosleep to let the IO complete
    movl    $0x1000, %eax
1:  subl    $1, %eax
    cmpl    $0, %eax
    jne     1b

    ## turn on the speaker
    inb     $0x61, %al
    movb    %al, %ah
    orb     $0x3, %al
    outb    %al, $0x61

    ## sleep about 1 sec
    ###movl    $0x30000000, %eax
    movl    $0x30000000, %eax
1:  subl    $1, %eax
    cmpl    $0, %eax
    jne     1b

    ## turn off the speaker
    movb    %ah, %al
    andb    $0xfc, %al
    outb    %al, $0x61


    xor     %ebx, %ebx  ## set return code 0
_exit:      # exit(%edi)
    popa
    movl    $0, %eax        ## set return value?
    ret     ## Craig - my new end is return.

    ###mov     $1, %eax   ## exit() == system call 60
    ###///syscall
    ###int $0x80

###message:
###    .ascii  "ioperm() failed, run as root or sudo\n"

