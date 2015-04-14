#!/bin/sh

# $1 = mimo/siso20/siso40

echo $@

root_path=/home/root
hw_type_fname=${root_path}/testing_wl_hw_type.txt

wlconf_path=/usr/sbin/wlconf
ini_files_path=${wlconf_path}/official_inis
ini_file=WL8_TESTING_INI.ini

wl18xx_conf_bin=/lib/firmware/ti-connectivity/wl18xx-conf.bin

ht_mimo=0
ht_siso20=2
ht_siso40=1

#
# verify ht_mode, options are: siso20, siso40, mimo
#
if [ "$1" == "siso20" ] ; then
    ht_mode=${ht_siso20}
elif  [ "$1" == "siso40" ] ; then
    ht_mode=${ht_siso40}
elif  [ "$1" == "mimo" ] ; then
    ht_mode=${ht_mimo}
    num_of_ant2_4=2
elif  [ "$1" == "default" ] ; then
    ht_mode=${ht_mimo}
else
    echo "wlcore: not supported ht mode"
    exit 1
fi

cd ${wlconf_path}
./wlconf -i ${wl18xx_conf_bin} -o ${wl18xx_conf_bin} --set wl18xx.ht.mode=${ht_mode}

if [ "$3" != "" ]; then
    if [ "$3" == "no-a-band" ]; then
        #
        # disabling A band is done by setting number_of_assembled_ant5 to 0
        #
        ./wlconf -i ${wl18xx_conf_bin} -o ${wl18xx_conf_bin} --set wl18xx.phy.number_of_assembled_ant5=0
    elif [ "$3" == "no-recovery" ]; then
        ./wlconf -i ${wl18xx_conf_bin} -o ${wl18xx_conf_bin} --set core.recovery.no_recovery=1
    else
	echo "wlcore: not supported"
	exit 1
    fi
fi

if [ "$4" != "" ]; then
    if [ "$4" == "no-a-band" ]; then
        #
        # disabling A band is done by setting number_of_assembled_ant5 to 0
        #
        ./wlconf -i ${wl18xx_conf_bin} -o ${wl18xx_conf_bin} --set wl18xx.phy.number_of_assembled_ant5=0
    elif [ "$4" == "no-recovery" ]; then
        ./wlconf -i ${wl18xx_conf_bin} -o ${wl18xx_conf_bin} --set core.recovery.no_recovery=1
    else
	echo "wlcore: not supported"
	exit 1
    fi
fi

./wlconf -i ${wl18xx_conf_bin} -g | grep -i "board\|ant\|ht.mode\|recovery\|dc2dc\|sta_sleep_auth\|low_band"

echo "wlcore: configuration ok"
exit 0

