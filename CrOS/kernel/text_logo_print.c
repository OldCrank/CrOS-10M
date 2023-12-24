// Craig 16-06-2023  Text logo print

#include "../drivers/screen.h"

void print_logo(unsigned char Lx, unsigned char Ly) {

	///int tmp = Lx + Ly;
	///tmp = tmp + tmp - tmp;
	///kprint("Printing logo\n");
	kprint_colour_at("Print at",RED_ON_BLACK,Lx,Ly);

	///printf("%d\n", tmp ); does not work here!

	char *LogoLines[18];
	LogoLines[0] = "@@@@@.                                                  .@@@@@";
	LogoLines[1] = "@@@@@@@@@@@..                                    ..@@@@@@@@@@@";                        
	LogoLines[2] = "         @@@@@@@@@@.                      .@@@@@@@@@@";
	LogoLines[3] = "  @@@@@           @@@@@@@.           .@@@@@@           @@@@@";
	LogoLines[4] = " @@@@                 @@@@@.      .@@@@@                 @@@@";
	LogoLines[5] = ".@@@        @@@@@@@    @@@@..    ..@@@@    @@@@@@@        @@@.";
	LogoLines[6] = ".@@@      @@@@@@@@@@    @@@..    ..@@@    @@@@@@@@@@      @@@.";
	LogoLines[7] = " .@@@     @@@@@@@@@@  @@@.         ..@@@  @@@@@@@@@@     @@@.";
	LogoLines[8] = "   .@@@     @@@@@@@  @@.              .@@  @@@@@@@     @@@.";
	LogoLines[9] = "       .@@@@@@@@@@@@.                    .@@@@@@@@@@@@@.";
	LogoLines[10] = "";
	LogoLines[11] = "";
	LogoLines[12] = "                           @@@@@@";
	LogoLines[13] = "                     @@@@@@      @@@@@";
	LogoLines[14] = "                   @@                 @@";
	LogoLines[15] = "                 @@                     @@";
	LogoLines[16] = "";
	LogoLines[17] = "";
	LogoLines[18] = "";
	////LogoLines[4] = "";


	int i = 0;
	while (i < 16){
		kprint_colour_at(LogoLines[i],RED_ON_BLACK,Lx,Ly);
		Ly++;
		i++;
	}
}


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