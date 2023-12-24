## Craig 25-08-2023.  my conversion of 32bit_print.asm
##  can't use bios calls in 32 bit mode.

.code32 #; using 32-bit protected mode

#; this is how constants are defined
VIDEO_MEMORY = 0xb8000
WHITE_OB_BLACK = 0x0f #; the color byte for each character

print_string_pm:
    pusha
    mov $VIDEO_MEMORY, %edx

print_string_pm_loop:
    mov (%ebx), %al    #; [ebx] is the address of our character
    mov $WHITE_OB_BLACK, %ah

    cmp $0, %al    #; check if end of string
    je print_string_pm_done

    mov %ax, (%edx)     #; store character + attribute in video memory
    add $1, %ebx     #; next char
    add $2, %edx     #; next video memory position

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret
