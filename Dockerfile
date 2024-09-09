# Start with an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Update and install necessary packages including Docker prerequisites
RUN apt-get update -q && \
    apt-get install -y wget git nano apt-transport-https ca-certificates curl software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker from the official Docker repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -q && \
    apt-get install -y docker-ce && \
    systemctl enable docker && \
    systemctl start docker

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

# Build the Docker image for the ceremony client
RUN docker build --build-arg GIT_COMMIT=$(git log -1 --format=%h) -t quilibrium -t quilibrium:latest .

# Run the Quilibrium node using Docker Compose
RUN docker compose up -d

# Keep the terminal alive
CMD ["tail", "-f", "/dev/null"]
