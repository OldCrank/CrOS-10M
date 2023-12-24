## Craig 31-8-2023. My conversion from switch_pm.asm (CrOS-04)
.code16
switch_to_pm:
    cli                      #; 1. disable interrupts
    lgdt gdt_descriptor     #; 2. load the GDT descriptor

  mov $0, %bh    ## set display page
  ####mov 0x1000, %al
  mov $'P', %al      ### Got this far ###
  mov $0x0e, %ah 
  int $0x10


    movl %cr0, %eax
    orl $0x1, %eax            #; 3. set 32-bit mode bit in cr0
    movl %eax, %cr0

##    movl $0x2f4b2f4f, 0xb80aa       # colour $2F + chars 'O' + 'K'


    ljmp $CODE_SEG, $init_pm   #; 4. far jump by using a different segment

.code32
init_pm:             #; we are now using 32-bit instructions
    ### Changing 0xb8470 to just 0xb847, fixed it to work in both QEMU an Bochs.
    ##movl $0x2f4b2f4f, 0xb8470       # colour $2F + chars 'O' + 'K'
    movl $0x2f4b2f4f, 0xb847       # colour $2F + chars 'O' + 'K'
    mov $DATA_SEG, %ax #; 5. update the segment registers
    mov %ax, %ds
    mov %ax, %ss
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    mov $0x90000, %ebp #; 6. update the stack right at the top of the free space
    mov %ebp, %esp

    call BEGIN_PM      #; 7. Call a well-known label with useful code
