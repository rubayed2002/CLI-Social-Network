#!/bin/bash

# Define the directory to store users
USER_DIR=~/cli_social_network/users

# Ask for the username
echo "Enter a username: "
read username

# Remove any leading/trailing whitespace from the username
username=$(echo "$username" | xargs)

# Check if the username already exists
if [ -e "$USER_DIR/$username" ]; then
    echo "Username already exists!"
    exit 1
fi

# Ask for the password
echo "Enter password: "
read -s password

# Create the user's file and store the hashed password
echo "$password" | sha256sum | cut -d ' ' -f 1 > "$USER_DIR/$username"

echo "User $username registered successfully!"
