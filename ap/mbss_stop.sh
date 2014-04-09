#!/bin/sh

########## variables ##########

AP1_DHCP_CONF=ud[h]cpd.conf
AP2_DHCP_CONF=ud[h]cpd2.conf

########## body ##########

echo "Terminating interfaces"
killall hostapd

output=`ps | grep $AP1_DHCP_CONF`
set -- $output
if [ -n "$output" ]; then
 kill $1
fi

output=`ps | grep $AP2_DHCP_CONF`
set -- $output               
if [ -n "$output" ]; then
 kill $1                 
fi 

if [ -d /sys/class/net/wlan1 ]
then                          
 iw wlan1 del
fi 

if [ -d /sys/class/net/wlan2 ]
then                          
 iw wlan2 del
fi 

