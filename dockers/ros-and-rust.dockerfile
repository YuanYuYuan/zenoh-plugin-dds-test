ARG USERNAME=user


# [Stage] ros-and-rust
FROM ros-base as base

# Reuse the ARG
ARG USERNAME

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
ENV PATH="/home/${USERNAME}/.cargo/bin:$PATH"
# Trigger the downloading for Rust components
RUN <<EOT
    mkdir /tmp/deleteme
    cd /tmp/deleteme
    cargo init
    cargo add zenoh
    rm -rf /tmp/deleteme
EOT


# [Stage] with-zenoh
FROM base AS ros-and-rust

# Reuse the ARG
ARG USERNAME
ARG WORKSPACE="/home/${USERNAME}/workspace"
# ARG ZENOH_PLUGIN_DDS_URL="https://github.com/eclipse-zenoh/zenoh-plugin-dds"
ARG ZENOH_PLUGIN_DDS_URL="https://github.com/atolab/zenoh-plugin-dds -b FAR5"

# Install zenoh-plugin-dds
RUN git clone ${ZENOH_PLUGIN_DDS_URL} ${WORKSPACE}/zenoh-plugin-dds
WORKDIR ${WORKSPACE}/zenoh-plugin-dds
RUN cargo build --release -p zenoh-bridge-dds
RUN cargo build --release -p zenoh-plugin-dds

# Install zenohd
RUN git clone https://github.com/eclipse-zenoh/zenoh ${WORKSPACE}/zenoh
WORKDIR ${WORKSPACE}/zenoh
RUN cargo build --release --bin zenohd
RUN cargo build --release -p zenoh-plugin-rest
RUN cargo build --release --example z_sub --example z_pub
RUN cp ${WORKSPACE}/zenoh-plugin-dds/target/release/libzenoh_plugin_dds.so ${WORKSPACE}/zenoh/target/release

# Install go to build minica
USER root
RUN apt install -y golang-go
