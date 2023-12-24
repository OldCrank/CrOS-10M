#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"
#include "../libc/mem.h"
#include "../libc/io.h"
#include "../libc/cr_time.h" 
#include <stdint.h>
#include "text_logo_print.h"
#include "../usrcmds/usrcmds.h"
#include "mysys.h"

struct cr_time curTime;

void kernel_main(void) {
	isr_install();
    irq_install();       

    // ## these next 2 lines seem to be just to show  ##
    // ## the interrupts are working. Prints to screen.
    ///asm("int $2");
    ///asm("int $3");

	//terminal_initialize();   // from tty.c
	
    clear_screen();                  // Clear up any messages left over from VBR boot sector.

    kprint_colour_at("CrOS v0.04.          Time is:                                                   \n", WHITE_ON_PURPLE, 0, 0);  // ### time will be filled in by timer.c get_time()
    

	// Test some stuff
	// Point to remember, each char in video mem is 2 bytes (1 word) long
	//   the char, then the colour
    /*
	char *base = (void *) 0xb8320;

	*base++ = 'X';
	*base++ = 0x0f;
	*base++ = 'O';
	*base++ = 0x0f;
    */

    print_logo(8,5);
    kprint("\n\nWelcome to CrOS!\n");
    kprint("ENTER at your peril...\n");

    mybeep2();

    //clear_screen();


}       // ## END OF KERNEL_MAIN ##


void user_input(char *input) {
    if (strcmp(input, "") == 0) {
        kprint("Are you doing finger exercises?");
    }
    else if (strcmp(input, "EXIT") == 0) {
        kprint("Stopping the CPU. Bye!\n");
        asm volatile("hlt");
    } 
    else if ((strcmp(input, "DIR") == 0) | (strcmp(input, "LS") == 0)) {
        kprint("File system not mounted.");
    }
    else if (strcmp(input, "CLEAR") == 0) {
        clear_screen();
    }
    else if (strcmp(input, "HELP") == 0) {
        cmd_help();
    }
    else if (strcmp(input, "BEEP") == 0) {
        mybeep2();
    }
    else if (strcmp(input, "PAGE") == 0) {
        /* Lesson 22: Code to test kmalloc, the rest is unchanged */
        uint32_t phys_addr;
        uint32_t page = kmalloc(1000, 1, &phys_addr);
        char page_str[16] = "";
        hex_to_ascii(page, page_str);
        char phys_str[16] = "";
        hex_to_ascii(phys_addr, phys_str);
        kprint("Page: ");
        kprint(page_str);
        kprint(", physical address: ");
        kprint(phys_str);
        kprint("\n");
    }
    else {
        kprint("I don't understand ");
        kprint(input);
        kprint(". Why do you feel like that!");
    }
    
    ///kprint("You said: ");
    ///kprint(input);
    kprint("\nWhat now-> ");
}

