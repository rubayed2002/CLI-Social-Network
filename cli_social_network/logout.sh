#!/bin/bash
# Log Out Script

LOGGED_IN_USER_FILE=~/cli_social_network/logged_in_user

if [ -f "$LOGGED_IN_USER_FILE" ]; then
    rm "$LOGGED_IN_USER_FILE"
    echo "You have been logged out successfully."
else
    echo "Error: No user is currently logged in."
fi
