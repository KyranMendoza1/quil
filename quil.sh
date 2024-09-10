#!/bin/bash

apt update
apt install curl
apt install wget

# Navigate to the home directory
cd ~

# Clone the ceremonyclient repository
git clone https://github.com/QuilibriumNetwork/ceremonyclient.git

# Change to the node directory within the cloned repository
cd ~/ceremonyclient/node

# Checkout the release branch
git checkout release

# Execute the release_autorun.sh script
./release_autorun.sh
