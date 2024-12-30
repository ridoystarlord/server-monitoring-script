#!/bin/bash

# Define remote server details
read -p "Enter the remote server IP: " SERVER_IP
read -p "Enter the remote server username (default: root): " USERNAME
USERNAME=${USERNAME:-root}

# Prompt for the remote server password
read -s -p "Enter the password for $USERNAME@$SERVER_IP: " SERVER_PASSWORD
echo

# Commands to be run on the remote server
REMOTE_COMMANDS=$(cat <<'ENDSSH'
# Update system packages
sudo apt-get update -y && sudo apt-get upgrade -y

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
fi

# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null
then
    echo "Installing Docker Compose..."
    sudo apt-get install -y docker-compose
fi

# Create monitoring directory
mkdir -p /root/monitoring

ENDSSH
)

# Use SSH with the provided password to execute commands
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$SERVER_IP" "$REMOTE_COMMANDS"

# Transfer files to the remote server
echo "Transferring files to the remote server..."
sshpass -p "$SERVER_PASSWORD" scp -r ./* "$USERNAME@$SERVER_IP:/root/monitoring"

# Start the monitoring service on the remote server
echo "Starting the monitoring service..."
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$SERVER_IP" "cd /root/monitoring && docker-compose down && docker-compose up -d"

echo "Setup complete! Monitoring service is running."
