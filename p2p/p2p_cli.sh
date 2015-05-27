#!/bin/sh

wpa_cli -i p2p-dev-wlan0 -p /var/run/wpa_supplicant/ $@
