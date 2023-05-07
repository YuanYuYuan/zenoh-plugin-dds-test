#!/usr/bin/env bash

export ROS_DOMAIN_ID=2
./target/release/pubsub -p /B -s /A -n N2
