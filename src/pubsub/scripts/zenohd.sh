#!/usr/bin/env bash

set -x

# /home/user/workspace/zenoh/target/release/zenohd -l tcp/127.0.0.1:7447
/home/user/workspace/zenoh/target/release/zenohd -c /home/user/workspace/zenoh-plugin-dds-test/configs/zenoh/core.json5
