# VNC Server Startup Script

This script sets up and starts the `x11vnc` server for remote access to your desktop environment. It allows you to choose between connecting to the login screen or an active user session.

## Features

- **Session Options**:
  - **Login Screen**: Provides access to the system's login interface. Useful for remote administration or troubleshooting.
  - **Regular Session**: Allows access to the currently logged-in user session.

- **Environment Configuration**: Default values for the display number, RFB port, password, and authentication file are stored in a `.env` file.

- **User Interaction**: The script prompts you to modify default values if desired.

## Prerequisites

- Ensure you have `x11vnc` installed on your system.
- You may need to install `x11vnc` using your package manager:
  ```bash
  # For Debian/Ubuntu
  sudo apt-get install x11vnc
  
  # For Fedora
  sudo dnf install x11vnc
  
  # For Arch
  sudo pacman -S x11vnc
  ```
## Usage

1. Save the script as `x11vnc_menu.sh`.
2. Make the script executable:
   ```bash
   chmod +x x11vnc_menu.sh
   ```
3. Run the script:
   ```bash
   ./x11vnc_menu.sh
   ```
4. Select the desired session type when prompted:
- Enter `1` for the **Login screen**.
- Enter `2` for a **Regular session**.

## Configuration

- The script will create a `.env` file in the same directory if it doesn't already exist. This file contains the following default values:
  - `DISPLAY_NUMBER`: The display number (default: `:0`).
  - `RFB_PORT`: The port for VNC (default: `10005`).
  - `PASSWORD`: A temporary password (default: `easy_password`). **NOTE: Please change this for security!**
  - `AUTH_FILE`: The authentication file (default: `~/.Xauthority`).

## Important Notes

- The temporary password `easy_password` is provided for convenience. **Please change this password for security purposes!**
- If you choose the **Login Screen** option, make sure to adjust the `AUTH_FILE` variable to point to the correct X authority file for your display manager.

## License

This script is provided as-is without any warranty. Use it at your own risk.

