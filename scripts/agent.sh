#!/usr/bin/env bash

# export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
# source /opt/ros/humble/setup.bash
# source /opt/workspace/install/setup.bash
# cd /opt/workspace
# ros2 run pubsub pub

# sleep $[ ( $RANDOM % 5 )  + 1 ]s
# /opt/zenoh-plugin-dds/target/release/zenoh-bridge-dds --mode peer --connect tcp/192.168.1.2:7447 --no-multicast-scouting

/opt/zenoh-plugin-dds/target/release/zenoh-bridge-dds \
  --mode peer \
  --connect tcp/127.0.0.1:7447 \
  --no-multicast-scouting
