# Start with an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Update and install necessary packages
RUN apt-get update -q && \
    apt-get install -y wget git && \
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

# Set the working directory to the ceremony client node folder
WORKDIR ~/ceremonyclient/node

# Checkout the release branch
RUN git checkout release

# Run the release_autorun.sh script
RUN ./release_autorun.sh

# Keep the terminal alive
CMD ["tail", "-f", "/dev/null"]
