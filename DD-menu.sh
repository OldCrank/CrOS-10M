#!/bin/bash

if [ ! -z "$1" ]
then
      echo
      echo "Image name supplied."
      echo "Building image:"
      HDDimg=$1
else
      echo
      echo "No image name supplied."
      echo "Building default image name:"
      # Set default disk image name here.
      HDDimg="testHDD.img"
      
fi



echo $HDDimg

PS3="Please select required action: "

items=("Build disk file" "Install MBR" "Install VBR" "Install Kernel" "RUN with Qemu" "RUN with Bochs" "Quit")

echo;
while true; do
  select opt in "${items[@]}"
  do
    echo;
      case $opt in
          "Build disk file")
              echo "$opt - creating empty disk image.";
              echo;
              dd if=/dev/zero of=$HDDimg bs=512 count=20808;
              break;;
          "Install MBR")
             echo "$opt - is disk image created?";
             echo "copying MBR onto $HDDimg.";
             dd if=./MBR/CrOS-MBR.bin of=$HDDimg bs=512 conv=notrunc && sync;
             echo;break;;
          "Install VBR")
             echo "$opt - install VBR.";
             exho "copying VBR onto $HDDimg.";
             dd if=./VBR/CrOS-VBR.bin of=$HDDimg bs=512 seek=17 conv=notrunc && sync;
             echo;break;;
          "Install Kernel")
             echo "$opt - copying kernel.bin onto $HDDimg.";
             dd if=./CrOS/kernel.bin of=$HDDimg bs=512 seek=19 conv=notrunc && sync
             echo;break;; 

          "RUN with Qemu")
             echo "$opt - booting $HDDimg under Qemu.";
             #qemu-system-i386 -s -hda testHDD.img
             qemu-system-i386 -s -hda $HDDimg
             echo;break;;  

          "RUN with Bochs")
             echo "$opt - booting $HDDimg under Bochs.";
             echo "Press c in bochs to continue past bochs break points.";
             bochs 'ata0-master: type=disk, path='$HDDimg', cylinders=306, heads=4, spt=17' 'boot: c'
             echo;break;;  

          "Quit")
             echo "We're done";echo;
             break 2;;
          *)
             echo "Ooops";break;;
      esac
  done
done  