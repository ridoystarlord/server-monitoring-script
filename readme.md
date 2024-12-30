# Instructions to Execute the Script from Git Bash on Windows, Linux, and macOS

This guide explains how to run the `setup_monitoring.sh` script on Windows (using Git Bash), Linux, and macOS. The script will set up Docker and Docker Compose on a remote Ubuntu VPS and deploy a monitoring service using Docker Compose.

---

## Prerequisites

1. **Access to the Remote Server**:

   - Ensure you have the IP address, username, and password for the remote Ubuntu server.

2. **Docker and Docker Compose Files**:

   - Place all necessary files (e.g., `docker-compose.yml`) in the same directory as the script.

3. **sshpass**:
   - Install `sshpass` to enable non-interactive SSH password authentication.

### Installing `sshpass`

- **On Windows (Git Bash)**:

  - Download the `sshpass` binary from a trusted source, such as [https://github.com/mbegan/sshpass/releases](https://github.com/mbegan/sshpass/releases).
  - Extract the `sshpass.exe` file and place it in a directory included in your system's `PATH`.
  - Verify the installation by running `sshpass -V` in Git Bash. If installed correctly, it will display the version information.

- **On Linux**:

  - Install `sshpass` using your package manager:
    ```bash
    sudo apt-get install sshpass  # For Debian/Ubuntu
    sudo yum install sshpass      # For CentOS/RHEL
    sudo pacman -S sshpass        # For Arch Linux
    ```

- **On macOS**:
  - Install `sshpass` using Homebrew:
    ```bash
    brew install hudochenkov/sshpass/sshpass
    ```

---

## Steps to Execute the Script

### 1. Download the Script

Save the `setup_monitoring.sh` script to your local machine.

### 2. Open the Terminal

- **Windows**: Launch Git Bash.
- **Linux/macOS**: Open your default terminal.

### 3. Navigate to the Script Directory

Use the `cd` command to move to the directory where the script is saved. For example:

```bash
cd /path/to/script
```

### 4. Edit & Give Permission on the script

open the script in your IDE and enter the `TARGET_SERVER` value(server ip). then execute the below cmd

```bash
chmod +x setup_monitoring.sh
```

### 5. Run the Script

Execute the script using the following command:

```bash
./setup_monitoring.sh
```

### 6. Enter the Remote Server Password

The script will prompt you to enter the password for the remote server. Enter it and press `Enter`.

---

## What the Script Does

1. **Checks and Installs Docker**:

   - Installs Docker and Docker Compose on the remote Ubuntu VPS if they are not already installed.

2. **Creates a Directory on the Remote Server**:

   - Creates the `/root/monitoring` directory and sets appropriate permissions.

3. **Transfers Files**:

   - Copies all files from your local machine to the `/root/monitoring` directory on the remote server.

4. **Deploys the Service**:
   - Navigates to the `/root/monitoring` directory and runs `docker-compose up -d` to start the service.

---

## Notes

1. **Ensure `sshpass` Works**:

   - If `sshpass` is not installed correctly, the script will fail to authenticate with the remote server.

2. **Error Handling**:

   - If the script encounters an error, it will stop. You can debug by running each section manually in the terminal.

3. **File Paths**:

   - Ensure the script and files are in a location accessible from your terminal.

4. **Security**:
   - Avoid hardcoding sensitive information like passwords in the script. Always enter the password manually when prompted.

---

## Troubleshooting

1. **`sshpass` Command Not Found**:

   - Ensure `sshpass` is installed and included in your system's `PATH`.

2. **Permission Denied Errors**:

   - Ensure the target directory on the remote server is writable by the script.

3. **Docker Compose Fails**:
   - Verify the contents of your `docker-compose.yml` file.

---

By following these instructions, you can successfully execute the `setup_monitoring.sh` script from Windows (Git Bash), Linux, or macOS.
