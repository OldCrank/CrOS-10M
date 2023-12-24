#include "timer.h"
#include "isr.h"
#include "ports.h"
#include "../libc/function.h"
#include "../drivers/screen.h"
#include "../libc/cr_time.h"
#include "../libc/string.h"

int cursorOffset;
uint32_t tick = 0;
// declare timcur as global
char  *timcur;
struct cr_time curTime;

static void timer_callback(registers_t *regs) {
    tick++;
    UNUSED(regs);
        
    if( tick > 20) {
        cursorOffset = get_cursor_offset();
        get_time(&curTime);
        char cHrs[4];
        char cmins[4];
        char csecs[4];
        itoa( curTime.Hours, cHrs);
        itoa( curTime.Mins, cmins);
        itoa( curTime.secs, csecs);
        // make sure all times are 2 char spaces.
        if (strlen(cHrs)<2) prepend(cHrs, '0');
        if (strlen(cmins)<2) prepend(cmins, '0');
        if (strlen(csecs)<2) prepend(csecs, '0');
        kprint_colour_at( "        ", WHITE_ON_PURPLE, 30, 0 );   // zero out time printing area.
        kprint_colour_at( cHrs , WHITE_ON_PURPLE, 30 , 0);
        kprint_colour_at( ":" , WHITE_ON_PURPLE, 32 , 0);
        kprint_colour_at( cmins , WHITE_ON_PURPLE, 33, 0);
        kprint_colour_at( ":" , WHITE_ON_PURPLE, 35 , 0);
        kprint_colour_at( csecs , WHITE_ON_PURPLE, 36, 0);
        //strpad( csecs, 2, "2" );  decided just to prepend a character
        set_cursor_offset( cursorOffset);


        tick = 0;
    }
}

void init_timer(uint32_t freq) {
    /* Install the function we just wrote */
    register_interrupt_handler(IRQ0, timer_callback);

    /* Get the PIT value: hardware clock at 1193180 Hz */
    uint32_t divisor = 1193180 / freq;
    uint8_t low  = (uint8_t)(divisor & 0xFF);
    uint8_t high = (uint8_t)( (divisor >> 8) & 0xFF);
    /* Send the command */
    port_byte_out(0x43, 0x36); /* Command port */
    port_byte_out(0x40, low);
    port_byte_out(0x40, high);
}

