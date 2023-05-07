FROM ros-base


ARG USERNAME=user

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
ENV PATH="/home/${USERNAME}/.cargo/bin:$PATH"
RUN mkdir /tmp/deleteme \
    && cd /tmp/deleteme \
    && cargo init \
    && cargo add zenoh \
    && rm -rf /tmp/deleteme

# Install zenoh-plugin-dds
WORKDIR /home/${USERNAME}/workspace
# RUN git clone https://github.com/eclipse-zenoh/zenoh-plugin-dds
RUN git clone https://github.com/atolab/zenoh-plugin-dds -b FAR5
RUN cd /home/${USERNAME}/workspace/zenoh-plugin-dds && cargo build --release -p zenoh-bridge-dds
