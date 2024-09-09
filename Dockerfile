# Start with an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Update and install necessary packages
RUN apt-get update -q && \
    apt-get install -y wget git nano systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify Git installation
RUN git --version

# Install Go
RUN wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz && \
    tar -xvf go1.22.4.linux-amd64.tar.gz && \
    mv go /usr/local && \
    rm go1.22.4.linux-amd64.tar.gz

# Apply the environment variables for Go
RUN echo "export GOROOT=/usr/local/go" >> ~/.bashrc && \
    echo "export GOPATH=/root/go" >> ~/.bashrc && \
    echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc && \
    source ~/.bashrc

# Verify Go installation
RUN go version

# Install gRPCurl using Go
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

# Clone the latest version of the ceremony client
RUN git clone https://github.com/QuilibriumNetwork/ceremonyclient.git ~/ceremonyclient

# Set the working directory to the ceremony client folder
WORKDIR ~/ceremonyclient

# Pull the latest updates and checkout the release branch
RUN git pull && git checkout release

# Set up systemd service for the Ceremony Client
RUN echo "[Unit]\n\
Description=Ceremony Client Go App Service\n\n\
[Service]\n\
Type=simple\n\
Restart=always\n\
RestartSec=5s\n\
WorkingDirectory=/root/ceremonyclient/node\n\
Environment=GOEXPERIMENT=arenas\n\
ExecStart=/root/ceremonyclient/node/release_autorun.sh\n\n\
[Install]\n\
WantedBy=multi-user.target" > /lib/systemd/system/ceremonyclient.service

# Enable the service to start on boot
RUN systemctl enable ceremonyclient.service

# Start the Ceremony Client service
RUN service ceremonyclient start

# Keep the terminal alive
CMD ["tail", "-f", "/dev/null"]
