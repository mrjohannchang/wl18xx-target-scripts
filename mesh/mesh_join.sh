#!/bin/sh

NETID=0
WPA_CLI='wpa_cli -i mesh0'
if [ $# -eq 0 ] || [ $# -eq 1 ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo ""
    echo "You must specify channel freq and Mesh ssid"
	echo "For secured link, add psk"
    echo "format: $0 [Mesh SSID] [freq] [psk]"
    echo ""
    exit
fi

NETID=`$WPA_CLI add_network | grep -v Using | grep -v Selected`

echo "netid="$NETID
echo "========================="
echo $WPA_CLI set_network $NETID ssid \'\""$1"\"\' > /usr/share/wl18xx/temp.txt
echo $WPA_CLI set_network $NETID mode 5 >> /usr/share/wl18xx/temp.txt
echo $WPA_CLI set_network $NETID frequency "$2" >> /usr/share/wl18xx/temp.txt

if [ $# -gt 2 ]; then
       echo $WPA_CLI set_network $NETID key_mgmt SAE >> /usr/share/wl18xx/temp.txt
       echo $WPA_CLI set_network $NETID psk \'\""$3"\"\' >> /usr/share/wl18xx/temp.txt
else
    echo $WPA_CLI set_network $NETID key_mgmt NONE >> /usr/share/wl18xx/temp.txt
fi

echo $WPA_CLI enable_network $NETID >> /usr/share/wl18xx/temp.txt
chmod 777 /usr/share/wl18xx/temp.txt
sh /usr/share/wl18xx/temp.txt
rm /usr/share/wl18xx/temp.txt

