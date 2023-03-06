#!/usr/bin/env bash

ip a | grep 192.168
sleep 100
# /opt/zenoh-plugin-dds/target/release/zenoh-bridge-dds --mode peer --connect tcp/192.168.0.2:7447 --no-multicast-scouting
