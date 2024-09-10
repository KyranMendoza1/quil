#!/bin/bash
# Update the package list and install necessary packages
apt update
apt install -y curl tmux

# Start a new tmux session named 'ceremony-session' and run the commands inside it
tmux new-session -d -s ceremony-session bash -c '
    # Navigate to the home directory
    cd ~

    # Clone the repository
    git clone https://github.com/QuilibriumNetwork/ceremonyclient.git

    # Navigate to the node directory within the cloned repository
    cd ~/ceremonyclient/node

    # Check out the release branch
    git checkout release

    # Run the release autorun script
    ./release_autorun.sh
'
