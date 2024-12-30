#!/bin/bash

# Define the target server and directory
TARGET_SERVER="<server ip>"
TARGET_USER="root"
TARGET_DIR="/root/monitoring"

# Prompt for password (for SSH access)
read -sp "Enter the password for $TARGET_USER@$TARGET_SERVER: " SERVER_PASSWORD
echo

# Function to install Docker and Docker Compose on Ubuntu (Linux)
install_docker_linux() {
  echo "Checking if Docker is installed on Ubuntu..."
  if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    usermod -aG docker $USER
    echo "Docker installed successfully."
  else
    echo "Docker is already installed."
  fi

  echo "Checking if Docker Compose is installed..."
  if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    echo "Docker Compose installed successfully."
  else
    echo "Docker Compose is already installed."
  fi
}

# Function to check local OS and execute the installation remotely
install_docker_on_remote() {
  REMOTE_OS=$(sshpass -p "$SERVER_PASSWORD" ssh $TARGET_USER@$TARGET_SERVER "uname -s" 2>/dev/null)
  echo "Remote OS: $REMOTE_OS"
  if [[ $REMOTE_OS == "Linux" ]]; then
    echo "Ubuntu (Linux) detected on the remote server."
    sshpass -p "$SERVER_PASSWORD" ssh $TARGET_USER@$TARGET_SERVER "$(declare -f install_docker_linux); install_docker_linux"
  else
    echo "The operating system of the remote server is not Ubuntu Linux. Please check manually."
    exit 1
  fi
}

# Install Docker and Docker Compose on the remote server
install_docker_on_remote

# Create the target directory and set permissions
echo "Creating monitoring directory on the remote server..."
sshpass -p "$SERVER_PASSWORD" ssh $TARGET_USER@$TARGET_SERVER "mkdir -p $TARGET_DIR && chmod 777 $TARGET_DIR"

# Copy the local files to the remote server
echo "Copying local files to the remote server..."
sshpass -p "$SERVER_PASSWORD" scp -r files/* $TARGET_USER@$TARGET_SERVER:$TARGET_DIR/

# Navigate to the directory and run Docker Compose
echo "Running Docker Compose on the remote server..."
sshpass -p "$SERVER_PASSWORD" ssh $TARGET_USER@$TARGET_SERVER "cd $TARGET_DIR && docker-compose down && docker-compose up -d"

echo "Setup completed successfully."
