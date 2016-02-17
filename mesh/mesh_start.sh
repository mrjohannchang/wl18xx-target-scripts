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

wpa_supplicant -e/usr/share/wl18xx/entropy.bin \
	-imesh0 -Dnl80211 -c mesh_supplicant.conf &

sleep 1	

iw phy phy0 set rts 0

ifconfig mesh0 10.20.30.40 netmask 255.255.255.0


