
# Craigs OS #

_⚠️ Hi! I have created this code has been for my personal experimemtion and exploring. 
It has been put together with info from lots of sources; including OSDEV.org, Carlos Fenollosa, and many others. I have seen that there has been technical criticism of some of these sources; as such I'm not suggesting this is a 'good' basis as an example, but still someone may find something useful from it.


## Description ##
Craigs OS (CrOS), is a 10MB HDD image. Boots from Master Boot Record, to Volume Boot Record, and finally a kernel program that provides for keyboard input with a limited number of built-in commands.
The assembly code uses GNU AT&T (GAS) syntax.
CrOS: includes time display, accepts keyboard input, displays messages, beeps.
During the MBR booting phase, it prints messages, and requests some keybosrd input;
then continues booting.

## My Path ##
The idea of producing my own Operating System appealed to me. I worked through OSdev BareBones & MeatySkeleton. I followed CFenollosa's tutorial. I wasn't entirely happy with the results. Firstly, I wanted to be booting from the absolute begining on a USB drive. Most examples either used the GRUB bootloader, or just a floppy image. (Who uses floppies these days). Secondly, I wanted to use GNU AT&T assembly code. I found that the majority of examples used the Intel syntax.

So I started Craigs OS (CrOS for short). I started off by DOS32 formatting a 16GB USB; and built the code for a Master Boot Record, and a Volume Boot Record. I DDed these onto the USB, and it would boot my OS, and was also still DOS readable. This was fine on real hardware (16GB USB), but I wouldn't want to be playing with too many 16GB disk images. So, I decided to work on a 10MB image for easier handling. ( I haven't put code for the 16GB image up, but I may later.).

I created the 10MB image using the DD program, and modifying my existing MBR, VBR code; I got the 10MB image booting my CrOS. Without the DOS formatting I have no file system though. Perhaps an adventure for another day.

## Building an image file ##
First go into MBR folder, and run 'make MBR'
Next go into VBR folder, and run 'make VBR'
Then go into CrOS folder, and run 'make kernel.bin'
This makes the 3 file you need on your HDD image. These 3 files are already part of this project.

I have created a shell script DD-menu.sh to create the final HDD image. 
This is in, and to be run from the base folder of the project.
This provides a 7 option menu:
1. Build disk file. This creates an empty 10MB file.
2. Install MBR. Uses DD program to copy MBR to master boot sector.
3. Install VBR. Uses DD program to copy VBR to volume boot sector.
4. Install Kernel. Uses DD program to copy kernel to disk image.
5. 5 & 6. allow for using emulators Qemu or Bochs if these programs are installed.
7. type 7 to Quit this script.

The default image name is testHDD.img. This can be overridden by supplying a name for the
image after script command; i.e. './DD-menu.sh differentname.img'


Temp modified text.