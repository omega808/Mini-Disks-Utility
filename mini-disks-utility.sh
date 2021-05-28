#!/bin/bash
#Uses the dd command to burn a iso image to a usb, or specified drive

#Counters for loops
N=0
B=0

#Functions for Program
get-drive(){
while [ $N -le 1 ];
do
	N=2

	lsblk
	read -p "Please choose the drive you want written to: " DRIVE

	if [[ "$DRIVE" =~ /$ ]];
	then
		echo "Please omit the /, at the of path!"
		sleep 1
		N=0
	fi

done

}

burn-iso(){
while [ $B -le 0 ];
do
	B=3
	
	read -p "Please enter full path of the iso image: " ISO

	if ! [  -f "$ISO" ];
	then
		echo "ISO image not found! Please renter the full path to ISO"
		sleep 1
		B=0
	fi
done

echo "Writing image now to Disk"
echo "This may take some time.."

sudo dd if=${ISO} of=${DRIVE} bs=1024k status=progress



}

erase-drive(){
	
	echo " What kind of wipe would you like?"
	read -p  "1: Quick Wipe 2: Long wipe[For paranoid security measures]" REPLY

	if [ $REPLY -eq 2 ];
	then
	
		echo "Wiping drive, this may take some time..."
		for n in `seq 7`; 
		do 
			dd if=/dev/urandom of=${DRIVE} bs=8b conv=notrunc
		done
	
	else
	then
		echo "Starting Quick Wipe.."
		sudo dd if=/dev/zero of=${DRIVE} bs=1M
	fi

	echo "Drive Wiped!"
}

format-drive(){

	echo "Choose filesystem to format too:"
	echo -e "1: Fat\n 2: NTFS\n 3: EXT4\n"
	read -p "   " FILESYS

	echo "Formatting..."
	case $FILESYS in
		1) sudo mkfs.vfat $DRIVE;;
		2) sudo mkfs.ntfs $DRIVE;;
		3) sudo mkfs.ext4 $DRIVE;;
	esac
	echo "Drive Formatted!"

}

get-drive
sleep 1

while [ $X eq 0 ];
do
	clear
	echo "*****************************************************************"
	echo "                   Mini Disk Utility                             "
	echo" "
	sudo blkid $DRIVE
	echo " Would you like to: "
	echo " 1- Format drive to FAT32"
	echo " 2- Erase all data from drive"
	echo " 3- Burn ISO to drive"
	echo " 4- Quit"
	read -p "  " REPLY

	case $REPLY in
		1) format-drive;;
		2) erase-drive;;
		3) burn-iso;;
		4) exit 0;;
	esac

done

	


exit 0
