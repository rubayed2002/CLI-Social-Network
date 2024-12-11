#!/bin/bash
# User Login

LOGGED_IN_USER_FILE=~/cli_social_network/logged_in_user

echo "Enter username: "
read username

user_file=~/cli_social_network/users/$username

# Check if user exists
if [ ! -f "$user_file" ]; then
    echo "User not found!"
    exit 1
fi

# Get the stored password hash
stored_password=$(cat "$user_file")

echo "Enter password: "
read -s password

# Check if entered password matches stored hash
entered_hash=$(echo $password | sha256sum | cut -d ' ' -f 1)
if [ "$entered_hash" != "$stored_password" ]; then
    echo "Incorrect password! Please try again."
    exit 1
fi

echo "$username" > "$LOGGED_IN_USER_FILE"
echo "Login successful! Welcome, $username."
