# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update and install the required prerequisites
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    python3 \
    python3-pip \
    openjdk-11-jdk \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Rust using the official installer
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set environment variables for Rust
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && rm get-docker.sh

# Install the Python packages globally
RUN pip3 install \
    poetry \
    pipenv \
    virtualenv

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# Clean up the package lists to reduce the image size
RUN apt-get clean

# Optionally, add a startup script or additional commands here
# COPY ./onstart.sh /root/onstart.sh
# RUN chmod +x /root/onstart.sh
# ENTRYPOINT ["/root/onstart.sh"]

# Set the working directory
WORKDIR /root

# Command to keep the terminal open and alive indefinitely
CMD ["bash", "-c", "while true; do sleep infinity; done"]
