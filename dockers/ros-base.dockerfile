# FROM osrf/ros:humble-desktop
# FROM osrf/ros:galactic-desktop
FROM osrf/ros:foxy-desktop

ARG DEBIAN_FRONTEND=noninteractive

# Use Taiwan mirrors
COPY ./taiwan-sources-focal.list /etc/apt/sources.list

# Update & upgrade
RUN apt update -y
RUN apt upgrade -y

# Setup timezone for Taiwan
RUN env DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install some utilities
RUN apt install -y iproute2 iputils-ping tmux zsh htop wireshark tshark heaptrack heaptrack-gui stow clang llvm

# CycloneDDS RMW
# # RUN apt install ros-humble-rmw-cyclonedds-cpp -y
# # RUN apt install ros-galactic-rmw-cyclonedds-cpp -y
RUN apt install ros-foxy-rmw-cyclonedds-cpp -y

# Create a sudo user
ARG USERNAME=user
RUN useradd -ms /bin/bash ${USERNAME}
RUN echo "${USERNAME}:${USERNAME}" | chpasswd
RUN apt install -y sudo
RUN adduser ${USERNAME} sudo

# Switch to user home directory
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Setup ROS2
# RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
RUN echo "source /opt/workspace/install/setup.bash" >> ~/.bashrc
