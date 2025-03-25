# Use Ubuntu as base image
FROM ubuntu:latest

# Install wget and dpkg
RUN apt-get update && apt-get install -y wget dpkg curl git libc6-dev

# Set working directory
WORKDIR /tcc-hardened-test

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint script
ENTRYPOINT ["/entrypoint.sh"]