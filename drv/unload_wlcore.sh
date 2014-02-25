#!/bin/sh

rmmod wlcore_sdio
rmmod wl18xx
rmmod wl12xx
rmmod wlcore
rmmod mac80211
rmmod cfg80211
rmmod compat

killall wpa_supplicant
killall hostapd
