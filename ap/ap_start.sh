#!/bin/sh

########## variables ##########

WLAN=wlan1
WLAN2=wlan2
HOSTAPD_PROC=/var/run/hostapd
HOSTAPD_CONF=/usr/share/wl18xx/hostapd.conf
HOSTAPD_BIN_DIR=/usr/local/bin
IP_ADDR=192.168.43.1
IP_ADDR2=192.168.53.1
DHCP_CONF=udhcpd.conf
DHCP_CONF2=udhcpd2.conf
DHCP_CONF_PROC=u[d]hcpd.conf
DHCP_CONF_PROC2=u[d]hcpd2.conf

########## body ##########

### check for configuration file
if [ ! -f $HOSTAPD_CONF ]; then
 if [ ! -f /etc/hostapd.conf ]
 then
  echo "error - no default hostapd.conf file"
  exit 1
 fi
 cp /etc/hostapd.conf $HOSTAPD_CONF
 chmod 777 $HOSTAPD_CONF
fi

### configure ip forewarding
echo 1 > /proc/sys/net/ipv4/ip_forward

### add WLAN interface, if not present
if [ ! -d /sys/class/net/$WLAN ]
then
  echo "adding $WLAN interface"
  iw phy `ls /sys/class/ieee80211/` interface add $WLAN type managed
fi

### start a hostapd interface, if not present
if [ ! -r $HOSTAPD_PROC ]
then
 $HOSTAPD_BIN_DIR/hostapd $HOSTAPD_CONF &
 sleep 1 
fi

### configure ip
ifconfig $WLAN $IP_ADDR netmask 255.255.255.0 up
if [ -d /sys/class/net/$WLAN2 ]
then
  ifconfig $WLAN2 $IP_ADDR2 netmask 255.255.255.0 up
fi

### start udhcpd server, if not started
output=`ps | grep /usr/share/wl18xx\$DHCP_CONF_PROC`
set -- $output
echo $output
if [ -z "$output" ]; then
  udhcpd $DHCP_CONF
fi

if [ -d /sys/class/net/$WLAN2 ]
then
  output=`ps | grep /usr/share/wl18xx\$DHCP_CONF_PROC2`                
  set -- $output
  echo $output
  if [ -z "$output" ]; then
    udhcpd $DHCP_CONF2
  fi
fi

### configure nat
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

