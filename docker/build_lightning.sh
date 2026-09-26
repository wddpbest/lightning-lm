#!/bin/bash

docker run --rm \
  -v "$(pwd)/../../..:/root/slam_ws" \
  -w /root/slam_ws \
  lightning-lm:dev \
  bash -c '
    source /opt/ros/humble/setup.bash
    colcon build --symlink-install --packages-select lightning
  '
