#!/bin/bash
# Post Message

# Check if the logged-in user is provided as an argument
if [ -z "$1" ]; then
    echo "Error: No logged-in user found. Please log in first."
    exit 1
fi

logged_in_user=$1  # Get the logged-in username from the argument

# Ensure the user's post file exists
user_post_file=~/cli_social_network/posts/$logged_in_user.txt
if [ ! -f "$user_post_file" ]; then
    touch "$user_post_file"  # Create the file if it doesn't exist
fi

# Get the current timestamp
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

echo "Enter your message: "
read message

# Save the message with username and timestamp to the user's post file
echo "Username: $logged_in_user" >> "$user_post_file"
echo "Timestamp: $timestamp" >> "$user_post_file"
echo "Message: $message" >> "$user_post_file"
echo "----------------------------------------" >> "$user_post_file"  # Separator for readability

echo "Message posted successfully!"
