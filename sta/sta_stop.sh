#!/bin/sh

wpa_cli -iwlan0 terminate
iw p2p0 del
