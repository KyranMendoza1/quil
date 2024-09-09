# Start with an Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV release_os="linux"
ENV release_arch="amd64"

# Install necessary packages and enable firewall rules
RUN apt-get -q update && \
    apt-get install -y sudo ufw curl && \
    sudo ufw enable && \
    sudo ufw allow 22 && \
    sudo ufw allow 8336 && \
    sudo ufw allow 443 && \
    sudo ufw status

# Create directories and navigate into them
RUN mkdir /ceremonyclient && cd /ceremonyclient && \
    mkdir node && cd node && \
    echo "3. Creating node folder, and downloading all required node-related files (binaries, .dgst and *.sig files)..." && \
    files=$(curl https://releases.quilibrium.com/release | grep $release_os-$release_arch) && \
    for file in $files; do \
        version=$(echo "$file" | cut -d '-' -f 2); \
        if ! test -f "./$file"; then \
            curl "https://releases.quilibrium.com/$file" -o "$file"; \
            echo "... downloaded $file"; \
        fi; \
    done && \
    chmod +x ./node-$version-$release_os-$release_arch && \
    cd .. && \
    echo "... download of required node files done" && \
    echo "4. creating client folder, and downloading qclient binary..." && \
    mkdir client && cd client && \
    echo "... client folder created" && \
    files=$(curl https://releases.quilibrium.com/qclient-release | grep $release_os-$release_arch) && \
    for file in $files; do \
        qclient_version=$(echo "$file" | cut -d '-' -f 2); \
        if ! test -f "./$file"; then \
            curl "https://releases.quilibrium.com/$file" -o "$file"; \
            echo "... downloaded $file"; \
        fi; \
    done && \
    mv qclient-$qclient_version-$release_os-$release_arch qclient && \
    chmod +x ./qclient && \
    cd .. && \
    echo "... download of required qclient files done"

# Default command to keep the container running
CMD ["tail", "-f", "/dev/null"]
