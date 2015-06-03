#!/bin/sh

# function for printing help
print_help()
{
        echo "Usage:  wlconf-toggle-set.sh <bin path> <feature> <mode> "
        echo "Please note that all the above require HW modifications."
        echo "      Feature Options: "       
		echo "      		'dual' 		- Dual Antenna"       
		echo "      		'zigbee'	- ZigBee Coex"       
		echo "      		'sync'		- Time Sync"       
}

# print help and exit if no argument were supplied
if [ $# -eq 0 ]; then
    print_help
	exit
fi

echo ""
echo "File: "$1""
echo "Feature: "$2""
echo "Mode (0-Disabled, 1-Enabled): "$3
echo ""

BIN_PATH=$1
FEATURE=$2
MODE=$3
cd /usr/sbin/wlconf
./wlconf -i $BIN_PATH -g > tmpconf.txt

#find feature place and replace with STUB
case $FEATURE in
                'dual')   sed 's/0x0/STUB/2' tmpconf.txt > tmp.txt;;
                'zigbee') sed 's/0x0/STUB/3' tmpconf.txt > tmp.txt;;
                'sync')   sed 's/0x0/STUB/4' tmpconf.txt > tmp.txt;;
                *) echo "Please enter dual/zigbee/sync"
esac

if [ "$3" == "1" ]; then
	#Turn it ON
	# replace STUB with value.
	echo "Enabling Feature: " $FEATURE
	sed 's/STUB0000000/0x00000001/' tmp.txt > tmp1.txt
elif [ "$3" == "2" ]; then
        #Set it to "2"
        # replace STUB with value.
        echo "Enabling Feature: " $FEATURE
        sed 's/STUB0000000/0x00000002/' tmp.txt > tmp1.txt
else	
	#Turn it OFF	
	# replace STUB with value.
	echo "Disabling Feature: " $FEATURE
	sed 's/STUB0000001/0x00000000/' tmp.txt > tmp1.txt
fi 

# Update the file
./wlconf -C tmp1.txt -o $BIN_PATH 

# Remove temp files
rm tmpconf.txt
rm tmp.txt
rm tmp1.txt

