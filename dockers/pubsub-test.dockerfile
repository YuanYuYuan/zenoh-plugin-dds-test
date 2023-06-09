FROM ros-and-rust

USER user

# Build pub & sub
WORKDIR /home/user/workspace/zenoh-plugin-dds-test/src/pubsub
COPY --chown=user:user src/pubsub .
SHELL ["/bin/bash", "--login", "-c"]
RUN source /opt/ros/foxy/setup.bash && cargo build --release --all-targets
