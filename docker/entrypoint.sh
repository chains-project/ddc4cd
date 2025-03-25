#!/bin/bash -e

# Fetch the latest release of tcc-hardened
deb_url=$(curl -s "https://api.github.com/repos/chains-project/ddc4cd/releases/latest" | \
          grep "browser_download_url.*\.deb" | cut -d '"' -f 4)

# Check if deb_url was found
if [[ -z "$deb_url" ]]; then
    echo "Error: Could not fetch latest .deb release."
    exit 1
fi

echo "Downloading latest release: $deb_url"

# resolve filename+url decode the + in filename, and ownload the .deb package
deb_file="/tmp/$(basename $deb_url | sed 's/%2B/+/g')"
wget -O "$deb_file" "$deb_url"

# Install the package
dpkg -i $deb_file || apt-get install -f -y

# dowload simple test file & test simple tcc-hardened functionality
wget -q https://raw.githubusercontent.com/chains-project/ddc4cd/refs/heads/main/hello.c
tcc-hardened hello.c -o hello

echo -e "\e[32mtcc-hardened successfully installed!\e[0m"
tcc-hardened -h

# Keep the container running
exec "$@"