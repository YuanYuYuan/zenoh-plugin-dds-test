#!/usr/bin/env bash

export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export CYCLONEDDS_URI=file:///home/user/workspace/zenoh-plugin-dds-test/configs/cdds/agent1.xml

set -x

# /home/user/workspace/zenoh-plugin-dds/target/release/zenoh-bridge-dds \
#     --domain 0 \
#     --mode client \
#     --connect tcp/127.0.0.1:7447

/home/user/workspace/zenoh-plugin-dds/target/release/zenoh-bridge-dds -c /home/user/workspace/zenoh-plugin-dds-test/configs/zenoh/agent.json5
# /home/user/workspace/zenoh-plugin-dds/target/release/zenoh-bridge-dds -c /home/user/workspace/zenoh-plugin-dds-test/configs/zenoh/client.json5
