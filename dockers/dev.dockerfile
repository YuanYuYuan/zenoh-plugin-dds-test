FROM ros-and-rust

# Install rust-analyzer
RUN mkdir -p ~/.local/bin
RUN curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
RUN chmod +x ~/.local/bin/rust-analyzer
RUN echo "export PATH='$HOME/.local/bin:$PATH'" >> ~/.bashrc

# Setup ROS2
# RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc
RUN echo "source /opt/workspace/install/setup.bash" >> ~/.bashrc

# Install some dev tools
RUN curl -L https://raw.githubusercontent.com/YuanYuYuan/dotfiles/main/install-zsh-nvim-tmux.sh | bash
RUN echo "source /opt/ros/foxy/setup.zsh" >> ~/.zshrc

# Source zsh to initialize zimfw
RUN /bin/zsh -c "source ~/.zshrc"
