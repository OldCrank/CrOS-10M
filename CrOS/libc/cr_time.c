/*   cr_time get_time requires cr_time struct to be initialised elsewhere in program.
    returns ints into cr_time struct variable.
*/

///#include "timer.h"
///#include "isr.h"
#include "../cpu/ports.h"
#include "../libc/function.h"
#include "cr_time.h"

int get_time( struct cr_time *curTime) {
  int hr = 0;
  int mins = 0;
  int secs = 0;
  int timezone = 4 ;  // Sydney ??

  /// ioperm( 0x70, 2, 1 );
  port_byte_out(0x70, 4);
  hr = port_byte_in(0x71);
  port_byte_out(0x70, 2);
  mins = port_byte_in(0x71);
  port_byte_out(0x70, 0);
  secs = port_byte_in(0x71);

  secs = (( secs / 16) * 10) + ( secs & 15);
  mins = (( mins / 16) * 10) + ( mins & 15);
  hr = hr + timezone;
  if ( hr > 23) hr -= 12;  
  curTime->Hours = hr;
  curTime->Mins = mins;
  curTime->secs = secs;
  return mins;
}
