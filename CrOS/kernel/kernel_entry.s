## 3-11-2023 Craig - converted from boot/kernel_entry.asm

.global _start
.code32

_start:
    ## .extern directive is supposedly does not do anything in GNU,
    ##   but kept failing until I included it?
    .extern kernel_main:      #; Define calling point. Must have same name as kernel.c 'main' function
    call kernel_main  #; Calls the C function. The linker will know where it is placed in memory
    ##jmp $
1:  jmp 1b
