# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install any desired packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Add a simple script to keep the container running
CMD ["tail", "-f", "/dev/null"]
