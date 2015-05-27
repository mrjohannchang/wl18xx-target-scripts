#!/bin/sh

if ps | grep -v grep | grep wpa_supplicant > /dev/null
then
    echo "wpa_supplicant is already running"
    exit 0
fi

if [ ! -f /usr/share/wl18xx/wpa_supplicant.conf ] 
then
 if [ ! -f /etc/wpa_supplicant.conf ]
 then
  echo "error - no default wpa_supplicant.conf"
  exit 1
 fi
 cp /etc/wpa_supplicant.conf /usr/share/wl18xx/wpa_supplicant.conf
fi

wpa_supplicant  -e/usr/share/wl18xx/entropy.bin \
        -iwlan0 -Dnl80211 -c/usr/share/wl18xx/wpa_supplicant.conf &

