#!/usr/bin/env bash

export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
/home/user/workspace/zenoh-plugin-dds/target/release/zenoh-bridge-dds \
    --domain 2 \
    --mode peer \
    --connect tcp/127.0.0.1:7447
