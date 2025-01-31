#!/bin/bash

# Define log path
LOG_FILE="/var/log/script_log.txt"

# Takes a message as an arguement and appends it to the log file with a timestamp.
# Function to log messages with timestamps
log() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Start logging
log "Script started."

# Example: Check for Apache installation and restart
log "Checking if Apache is installed..."
if systemctl list-units --type=service | grep -q apache2; then
    log "Apache is installed. Restarting Apache..."
    sudo systemctl restart apache2
    if [ $? -eq 0 ]; then
        log "Apache restarted successfully."
    else
        log "Failed to restart Apache."
    fi
else
    log "Apache is not installed."
fi

# Example: Check for Nginx installation and restart
log "Checking if Nginx is installed..."
if systemctl list-units --type=service | grep -q nginx; then
    log "Nginx is installed. Restarting Nginx..."
    sudo systemctl restart nginx
    if [ $? -eq 0 ]; then
        log "Nginx restarted successfully."
    else
        log "Failed to restart Nginx."
    fi
else
    log "Nginx is not installed."
fi

# End logging
log "Script finished."
