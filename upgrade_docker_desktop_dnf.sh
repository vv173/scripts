#!/bin/bash

# Function to display usage information
display_usage() {
    echo "Usage: $0 -u <url> [-h]"
    echo "  -u Specify the link to the Docker Desktop RPM package (mandatory)"
    echo "  -h Display this help message"
    exit 1
}

# Check if script is running with sudo privileges
if [ "$UID" -ne 0 ] || [ "$EUID" -ne 0 ]; then
	echo "Error: This script must be run with sudo privileges."
	exit 1
fi

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    display_usage
fi

# Parse command line arguments
while getopts ":u:h" opt; do
    case $opt in
        u)
            URL="$OPTARG"
            ;;
        h)
            display_usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            display_usage
            ;;
    esac
done

# Check if url is provided
if [ -z "$URL" ]; then
    echo "Error: Docker Desktop RPM package link (-u) is mandatory."
    display_usage
fi

# Initialize variables
DOCKER_DESKTOP_RPM=$(basename "$URL")

# Download Docker Desktop RPM
echo "Downloading Docker Desktop RPM package: $DOCKER_DESKTOP_RPM..."
curl -o "$DOCKER_DESKTOP_RPM" "$URL"

# Remove old versions of Docker Desktop
echo "Removing old Docker Desktop versions..."
dnf remove -y docker-desktop

# Install the newest Docker Desktop
echo "Installing Docker Desktop version $VERSION..."
dnf install -y "./$DOCKER_DESKTOP_RPM"

# Error handling
if [ $? -ne 0 ]; then
    echo "Error: Failed to install Docker Desktop."
    exit 1
fi

echo "Clean up: Remove the downloaded RPM file"
rm -f "$DOCKER_DESKTOP_RPM"

echo "Docker Desktop installation completed successfully!"
