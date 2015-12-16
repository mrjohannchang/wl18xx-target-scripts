#!/bin/sh
. ./debug_level

function usage ()
{
    echo "Usage: <fw/driver> <conf>"
	echo "options:"
	echo "fw 	 - Set firmware traces (saved)"
	echo "driver - Set driver traces (saved)"
	echo "conf - Configure traces and"	
	exit 1
}

print_state()
{
	debug_conf=("${!1}")
    echo "---"
    echo "Current configuration :"
    echo "---"
    i="0"
    while [ $i -lt ${#debug_conf[@]} ]; do
        idx=$((i/2))
        echo $idx") "${debug_conf[i+1]} " : "  ${debug_conf[i]}
	i=$[$i + 2] 
    done
}

toggle_conf()
{
    debug_conf=("${!1}")  
    a_size=$((${#debug_conf[@]}/2))
   
	selection=
    until [ "$selection" = "s" ]; do
		print_state debug_conf[@] 
		
		echo ""
		echo "Select # to toggle"
		echo "'s' - Save and set "
		echo "'q' - Quit and do nothing"
		echo ""
		echo -n "Enter selection: "
		read selection
		echo "" 
		case $selection in
			[0-9]|1[0-9]) 
					idx=$((selection*2))  
					echo "Toggeling "${debug_conf[idx]} 
					new_mode=$((1 ^ ${debug_conf[idx+1]}))
					debug_conf[idx+1]=$new_mode
					sed -i "/${debug_conf[idx]}/{n;s/.*/$new_mode/}" debug_level  				
					;;
			s) echo "---" ;;
			* ) echo "ERROR : Please enter a valid value"
		esac
    done

}


function set_debug_level()
{
    debug_conf=("${!1}")
    DEBUG_LEVEL=0
	
	#Manual configuration of debug
	if [[ $2 == "conf" ]]
	then
		toggle_conf debug_conf[@] 
	fi
	
    i="0"
    while [ $i -lt ${#debug_conf[@]} ]; do   
		idx=$((i/2))	
		#If configuration is enabled, count it.
		if [[ ${debug_conf[i+1]} == "1" ]] 
		then   
			decimal=$((1 << $idx))
			echo " Enabled - "${debug_conf[i]} 
			DEBUG_LEVEL=$(($DEBUG_LEVEL+decimal))
		fi
		
		i=$[$i + 2]
    done

}

# print help and exit if no argument were supplied
if [ $# -eq 0 ]; then
    usage
    exit
fi 

if [[ $1 == "fw" ]]
then    
	set_debug_level fw_config[@] $2    
    printf -v result "%x" "$DEBUG_LEVEL"   
    
	echo ""
	echo "Configuring FW debug :"
    echo "echo 0x"$result ">  /sys/kernel/debug/ieee80211/phy0/wlcore/wl18xx/dynamic_fw_traces"
    echo $result >  /sys/kernel/debug/ieee80211/phy0/wlcore/wl18xx/dynamic_fw_traces
fi

if [[ $1 == "driver" ]]
then
	set_debug_level driver_config[@] $2
	printf -v result "%x" "$DEBUG_LEVEL"   
	
	echo ""	
	echo "Configuring Driver debug :"
	echo -n 'module wlcore +p' > /sys/kernel/debug/dynamic_debug/control
	echo -n 'module wl18xx +p' > /sys/kernel/debug/dynamic_debug/control
	echo -n 'module mac80211 +p' > /sys/kernel/debug/dynamic_debug/control
	echo -n 'module cfg80211 +p' > /sys/kernel/debug/dynamic_debug/control	
	echo 8 > /proc/sys/kernel/printk
    echo "echo 0x"$result ">  /sys/module/wlcore/parameters/debug_level"
	echo $result > /sys/module/wlcore/parameters/debug_level
    
fi 


exit
