#!/system/bin/sh

PHY=`ls /sys/class/ieee80211/`
mkdir -p /debug
mount -t debugfs none /debug/

echo
echo ------- DRIVER STATISTICS -------
cat /debug/ieee80211/$PHY/wlcore/driver_state
echo
echo
echo ------- FIRMWARE STATISTICS -------
echo
sh wlcore-print-fw-stat.sh stat 
echo
echo ------- END -------
cd /
