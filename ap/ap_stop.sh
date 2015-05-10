#!/bin/sh

########## variables ##########

WLAN=wlan1
WLAN2=wlan2
DHCP_CONF=ud[h]cpd.conf
DHCP_CONF2=ud[h]cpd2.conf

########## body ##########

echo "Terminating DHCP"
if [ -d /sys/class/net/$WLAN1 ]
then 
  output=`ps | grep $DHCP_CONF`
  set -- $output
  if [ -n "$output" ]; then
    kill $1
  fi
fi

if [ -d /sys/class/net/$WLAN2 ]
then
  output=`ps | grep $DHCP_CONF2`
  set -- $output
  if [ -n "$output" ]; then
    kill $1
  fi
fi

echo "Terminating hostapd"
killall hostapd
