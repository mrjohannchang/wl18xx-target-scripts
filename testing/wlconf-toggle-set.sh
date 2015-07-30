#!/bin/sh

# function for printing help
print_help()
{
        echo "Usage:  wlconf-toggle-set.sh <bin path> <feature> <mode> "
        echo "Please note that all the above require HW modifications."
        echo "      Feature Options: "       
		echo "      		'dual' 		- Dual Antenna"       
		echo "      		'zigbee'	- ZigBee Coex"       
		echo "      		'sync'		- Time Sync (1-Station, 2 - AP)"
}

# print help and exit if no argument were supplied
if [ $# -eq 0 ]; then
    print_help
	exit
fi


BIN_PATH=$1
FEATURE=$2
MODE=$3

if [ $1 == "def" ]; then
	BIN_PATH="/lib/firmware/ti-connectivity/wl18xx-conf.bin"
        echo ""
fi

if [ ! -f $BIN_PATH ]; then

        echo ""
		echo " *** bin file not found : " $BIN_PATH
        echo ""
        print_help
exit
fi

echo ""
echo "File: "$1""
echo "Feature: "$2""
echo "Mode : "$3
echo ""

cd /usr/sbin/wlconf
./wlconf -i $BIN_PATH -g > org_conf.txt

#find feature place and replace with STUB
case $FEATURE in
                'dual')   sed '4 s/0x0000/STUB/2' org_conf.txt > tmp.txt;;
                'zigbee') sed '4 s/0x0000/STUB/3' org_conf.txt > tmp.txt;;
                'sync')   sed '4 s/0x0000/STUB/4' org_conf.txt > tmp.txt;;
                *) echo "Please enter dual/zigbee/sync"
esac

if [ "$3" == "1" ]; then
	#Turn it ON
	# replace STUB with value.
	echo "Enabling Feature: " $FEATURE
	sed 's/STUB[^ ]*/0x00000001,/' tmp.txt > updated_conf.txt
elif [ "$3" == "2" ]; then
        #Set it to "2"
        # replace STUB with value.
        echo "Enabling Feature: " $FEATURE
        sed 's/STUB[^ ]*/0x00000002,/' tmp.txt > updated_conf.txt
else	
	#Turn it OFF	
	# replace STUB with value.
	echo "Disabling Feature: " $FEATURE
	sed 's/STUB[^ ]*/0x00000000,/' tmp.txt > updated_conf.txt
fi 

# Update the file
./wlconf -C updated_conf.txt -o $BIN_PATH 
./wlconf -i $BIN_PATH -g | grep sg

# Remove temp files
rm org_conf.txt
rm tmp.txt
rm updated_conf.txt

