#!/bin/bash

# .env file path
ENV_FILE=".env"

# Function to create .env file with default values if it doesn't exist
create_env_file() {
    if [[ ! -f "$ENV_FILE" ]]; then
        echo "Creating .env file with default values..."
        cat <<EOL > "$ENV_FILE"
# Default configuration
DISPLAY_NUMBER=":0"
RFB_PORT="10005"
PASSWORD="easy_password"  # NOTE: This is a temporary password. Please change it for security!
AUTH_FILE="$HOME/.Xauthority"  # Default auth file
EOL
    else
        echo ".env file already exists."
    fi
}

# Load .env variables
load_env() {
    if [[ -f "$ENV_FILE" ]]; then
        echo "Loading environment variables from .env file..."
        source "$ENV_FILE"
    else
        echo "Error: .env file not found!"
        exit 1
    fi
}

# Function to print current default values from .env
print_env_values() {
    echo "Current default values:"
    echo "  Display Number: $DISPLAY_NUMBER"
    echo "  RFB Port: $RFB_PORT"
    echo -n "  VNC Password: $PASSWORD"

    # Print the note only if the password is the default one
    if [[ "$PASSWORD" == "easy_password" ]]; then
        echo " (NOTE: This is a temporary password. Please change it!)"
    else
        echo ""
    fi
}

# Function to allow user to modify default values in .env
modify_env_file() {
    echo "Do you want to modify the default values in .env? (y/n)"
    read -rp "Your choice: " modify_choice

    if [[ "$modify_choice" == "y" || "$modify_choice" == "Y" ]]; then
        read -rp "Enter new Display Number (current: $DISPLAY_NUMBER): " new_display
        read -rp "Enter new RFB Port (current: $RFB_PORT): " new_rfbport
        read -rp "Enter new VNC Password (current: $PASSWORD): " new_password
        read -rp "Enter new AUTH File (current: $AUTH_FILE): " new_auth

        # Use current values if the user leaves the input empty
        new_display="${new_display:-$DISPLAY_NUMBER}"
        new_rfbport="${new_rfbport:-$RFB_PORT}"
        new_password="${new_password:-$PASSWORD}"
        new_auth="${new_auth:-$AUTH_FILE}"

        # Update the .env file with the new defaults
        cat <<EOL > "$ENV_FILE"
# Default configuration
DISPLAY_NUMBER="$new_display"
RFB_PORT="$new_rfbport"
PASSWORD="$new_password"
AUTH_FILE="$new_auth"
EOL
        echo ".env file updated with new default values!"
    fi
}

# Function to start x11vnc with given parameters
start_vnc() {
    local display_number="$1"
    local rfb_port="$2"
    local password="$3"
    local auth_file="$4"

    echo "Starting x11vnc with Display: $display_number, Port: $rfb_port"
    x11vnc -display "$display_number" -forever -shared -rfbport "$rfb_port" -auth "$auth_file" -passwd "$password"
}

# Stop running x11vnc process, if any
stop_vnc() {
    if pgrep x11vnc > /dev/null; then
        echo "Stopping existing x11vnc process..."
        killall x11vnc
    else
        echo "No existing x11vnc process found."
    fi
}

# --- Main script logic ---

echo "Select session type:"
echo "1. Login screen"
echo "2. Regular session"
read -rp "Choose an option (1 or 2): " session_choice

case "$session_choice" in
    1)
        # Login screen option
        echo "Starting x11vnc for the login screen..."
        AUTH_FILE="/var/gdm/:0.Xauth"  # Adjust for your system
        ;;
    2)
        # Regular session option
        echo "Starting x11vnc for the regular session..."
        AUTH_FILE="$HOME/.Xauthority"  # Default auth file
        ;;
    *)
        echo "Invalid option selected. Exiting."
        exit 1
        ;;
esac

# Create .env file if it doesn't exist
create_env_file

# Load environment variables from .env file
load_env

# Print current values after loading .env file
print_env_values

# Ask the user if they want to modify the default values in .env
modify_env_file

# Reload the environment variables after possible modification
load_env

# Stop any existing x11vnc process before starting a new one
stop_vnc

# Start x11vnc with loaded or modified parameters
start_vnc "$DISPLAY_NUMBER" "$RFB_PORT" "$PASSWORD" "$AUTH_FILE"
