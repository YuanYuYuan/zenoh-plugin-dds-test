#!/usr/bin/env bash

# export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# source /opt/ros/humble/setup.bash
# source /opt/workspace/install/setup.bash
# cd /opt/workspace
# ros2 run pubsub sub

# bash
# /opt/zenoh-plugin-dds/target/release/zenoh-bridge-dds --mode peer --listen tcp/192.168.1.2:7447 --no-multicast-scouting
/opt/zenoh-plugin-dds/target/release/zenoh-bridge-dds --mode peer --listen tcp/127.0.0.1:7447 --no-multicast-scouting
