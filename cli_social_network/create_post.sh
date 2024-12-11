#!/bin/bash
# Create Post Script

LOGGED_IN_USER_FILE=~/cli_social_network/logged_in_user
POSTS_FILE=~/cli_social_network/posts.txt

if [ ! -f "$LOGGED_IN_USER_FILE" ]; then
    echo "Error: You must log in to create a post."
    exit 1
fi

logged_in_user=$(cat "$LOGGED_IN_USER_FILE")

echo "Enter your message: "
read message

# Ensure the posts file exists
if [ ! -f "$POSTS_FILE" ]; then
    touch "$POSTS_FILE"
fi

timestamp=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$timestamp] $logged_in_user: $message" >> "$POSTS_FILE"

echo "Message posted successfully!"
