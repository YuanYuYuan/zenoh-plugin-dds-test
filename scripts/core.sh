#!/usr/bin/env bash

# bash
/opt/zenoh-plugin-dds/target/release/zenoh-bridge-dds --mode peer --listen tcp/192.168.1.2:7447 --no-multicast-scouting
