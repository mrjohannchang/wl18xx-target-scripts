MESH=mesh0
### add Mesh interface, if not present
if [ ! -d /sys/class/net/$MESH ]
then
  echo "adding $MESH interface"
  iw phy `ls /sys/class/ieee80211/` interface add $MESH type mp
fi

if ps -w | grep -v grep | grep wpa_supplicant | grep mesh0 > /dev/null
then
    echo "wpa_supplicant is already running(Mesh)"
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

wpa_supplicant -e/usr/share/wl18xx/entropy.bin \
    -iwlan0 -Dnl80211 -c/usr/share/wl18xx/wpa_supplicant.conf -N\
    -imesh0 -Dnl80211 -c/usr/share/wl18xx/mesh_supplicant.conf &

sleep 1	
