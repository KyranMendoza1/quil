#!/bin/bash

# Update package lists and install necessary packages
apt update
apt install -y curl wget tmux

# Create or attach to a tmux session named quil-session
tmux new-session -d -s quil-session

# Run the commands inside the tmux session
tmux send-keys -t quil-session 'apt update' C-m
tmux send-keys -t quil-session 'apt install -y curl wget' C-m

# Navigate to the home directory
tmux send-keys -t quil-session 'cd ~' C-m

# Clone the ceremonyclient repository
tmux send-keys -t quil-session 'git clone https://github.com/QuilibriumNetwork/ceremonyclient.git' C-m

# Change to the node directory within the cloned repository
tmux send-keys -t quil-session 'cd ~/ceremonyclient/node' C-m

# Checkout the release branch
tmux send-keys -t quil-session 'git checkout release' C-m

# Execute the release_autorun.sh script
tmux send-keys -t quil-session './release_autorun.sh' C-m

# Attach to the tmux session
tmux attach-session -t quil-session
