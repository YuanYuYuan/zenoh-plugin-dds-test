#!/usr/bin/env bash

export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export ROS_DOMAIN_ID=1
./target/release/pubsub -p /A -s /B -n N1
