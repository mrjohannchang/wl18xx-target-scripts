#!/bin/sh

########## variables ##########

HOSTAPD_CONF=/usr/share/wl18xx/hostapd.conf
HOSTAPD_BIN_DIR=/usr/local/bin             
AP1_IP_ADDR=192.168.43.1                   
AP2_IP_ADDR=192.168.53.1                   
AP1_DHCP_CONF=udhcpd.conf     
AP2_DHCP_CONF=udhcpd2.conf
AP1_DHCP_CONF_PROC=u[d]hcpd.conf
AP2_DHCP_CONF_PROC=u[d]hcpd2.conf

########## body ##########

### check for configuration file
if [ ! -f $HOSTAPD_CONF ]; then
 if [ ! -f /etc/hostapd.conf ]
 then
  echo "error - no default hostapd.conf"
  exit 1
 fi
 cp /etc/hostapd.conf $HOSTAPD_CONF
 chmod 777 $HOSTAPD_CONF
fi

### configure ip forewarding
echo 1 > /proc/sys/net/ipv4/ip_forward

### add WLAN interface, if not present                 
if [ ! -d /sys/class/net/wlan1 ]                       
then                                                   
  echo "adding interface wlan1"                        
  iw phy `ls /sys/class/ieee80211/` interface add wlan1 type managed
fi 

### add ap interface
$HOSTAPD_BIN_DIR/hostapd $HOSTAPD_CONF &

### configure ip wlan1
ifconfig wlan1 $AP1_IP_ADDR netmask 255.255.255.0 up

### start udhcpd server, if not started
output=`ps | grep /usr/share/wl18xx\$AP1_DHCP_CONF_PROC`
set -- $output
echo $output
if [ -z "$output" ]; then
 udhcpd $AP1_DHCP_CONF
fi

### configure ip wlan2
ifconfig wlan2 $AP2_IP_ADDR netmask 255.255.255.0 up

### start udhcpd server, if not started
output=`ps | grep /usr/share/wl18xx\$AP2_DHCP_CONF_PROC`                            
set -- $output                                                                  
echo $output                                                                    
if [ -z "$output" ]; then                                                       
 udhcpd $AP2_DHCP_CONF                                                           
fi 

### configure nat
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

