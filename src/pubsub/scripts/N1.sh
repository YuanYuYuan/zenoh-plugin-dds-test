#!/usr/bin/env bash

# export ROS_DOMAIN_ID=1
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=file:///home/user/workspace/zenoh-plugin-dds-test/configs/cdds/agent1.xml

# ros2 run demo_nodes_cpp talker

# ./target/release/pubsub -p /A -s /B -n N1
./target/release/pubsub -p /DataReq_Msg -s /DataReply_Msg -n N1
