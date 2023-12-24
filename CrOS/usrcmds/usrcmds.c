// Craig 16-06-2023  User Commands.

#include "../drivers/screen.h"
#include "../cpu/ports.h"

void cmd_help() {
	kprint("\nAvailable commands:\n");
  kprint("  BEEP - plays beep sound.\n");
	kprint("  CLEAR - clears screen.\n");
	kprint("  DIR - informs you there is no file system.\n");
	kprint("  HELP - prints out list of available commands.\n");
	kprint("  EXIT - stops the kernel.\n");
}

/*
void beep() {

}
*/

/*
@@@@@.                                                  .@@@@@          
@@@@@@@@@@@..                                    ..@@@@@@@@@@@         
         @@@@@@@@@@.                      .@@@@@@@@@@                   
  @@@@@           @@@@@@@.           .@@@@@@           @@@@@
 @@@@                 @@@@@>.    .<@@@@@                 @@@@         
.@@@        @@@@@@@    @@@@..    ..@@@@    @@@@@@@        @@@.         
.@@@      @@@@@@@@@@    @@@..    ..@@@    @@@@@@@@@@      @@@.         
 .@@@     @@@@@@@@@@  @@@.         ..@@@  @@@@@@@@@@     @@@.          
   .@@@     @@@@@@@  @@.              .@@  @@@@@@@     @@@.          
       .@@@@@@@@@@@@.                    .@@@@@@@@@@@@@.            

       
                            @@@@@@           
                      @@@@@@      @@@@@                                  
                    @@                 @@                                
                  @@                     @@ 

*/                  