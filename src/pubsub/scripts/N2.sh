#!/usr/bin/env bash

# export ROS_DOMAIN_ID=2
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=file:///home/user/workspace/zenoh-plugin-dds-test/configs/cdds/agent2.xml


# ros2 run demo_nodes_cpp listener

./target/release/pubsub -p /ZenohTestTopicB -s /ZenohTestTopicA -n N2
# ./target/release/pubsub -p /B -s /A -n N2
# ./target/release/pubsub -s /DataReq_Msg -p /DataReply_Msg -n N2
