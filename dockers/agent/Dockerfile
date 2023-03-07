FROM osrf/ros:humble-desktop

ARG DEBIAN_FRONTEND=noninteractive

# Use Taiwan mirrors
COPY ./taiwan-sources.list /etc/apt/sources.list

# Update & upgrade
RUN apt update -y
RUN apt upgrade -y

# Setup timezone for Taiwan
RUN env DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Taipei /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install some utilities
RUN apt install -y iproute2 iputils-ping

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
ENV PATH="/root/.cargo/bin:$PATH"
RUN mkdir /tmp/deleteme \
    && cd /tmp/deleteme \
    && cargo init \
    && cargo add serde \
    && rm -rf /tmp/deleteme

# Install zenoh-plugin-dds
RUN git clone https://github.com/eclipse-zenoh/zenoh-plugin-dds /opt/zenoh-plugin-dds
RUN apt install -y clang
RUN cd /opt/zenoh-plugin-dds && cargo build --release -p zenoh-bridge-dds
