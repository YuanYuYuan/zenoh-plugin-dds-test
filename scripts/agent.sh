#!/usr/bin/env bash

# bash
# sleep $[ ( $RANDOM % 5 )  + 1 ]s
/opt/zenoh-plugin-dds/target/release/zenoh-bridge-dds --mode peer --connect tcp/192.168.1.2:7447 --no-multicast-scouting
