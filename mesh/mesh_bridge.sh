#!/bin/sh

ifconfig eth0 0.0.0.0
ifconfig mesh0 0.0.0.0
brctl addbr br0
brctl addif br0 mesh0
brctl addif br0 eth0
udhcpc -i br0

