#!/bin/bash
# Script to add a comment to a post

POSTS_FILE=~/cli_social_network/posts.txt
LOGGED_IN_USER_FILE=~/cli_social_network/logged_in_user

# Check if the user is logged in
if [ ! -f "$LOGGED_IN_USER_FILE" ]; then
    echo "Error: You must log in to comment on posts."
    exit 1
fi

logged_in_user=$(cat "$LOGGED_IN_USER_FILE")

# Ask for the post number to comment on
echo "Enter the post number you want to comment on: "
read post_number

# Validate input
if ! [[ "$post_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a valid post number."
    exit 1
fi

# Get the selected post and ensure it exists
selected_post=$(awk -v post_number="$post_number" '
    BEGIN { current_post = 0 }
    /^\[/ { 
        current_post++;
        if (current_post == post_number) {
            print $0; 
            exit;
        }
    }
' "$POSTS_FILE")

if [ -z "$selected_post" ]; then
    echo "Invalid post number. No such post exists."
    exit 1
fi

echo "You selected the following post:"
echo "$selected_post"

# Ask for the comment
echo "Enter your comment: "
read user_comment

# Get the current timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Format the comment
formatted_comment="\t[${timestamp}] ${logged_in_user}: ${user_comment}"

# Add the comment to the selected post
awk -v post_number="$post_number" -v comment="$formatted_comment" '
    BEGIN { current_post = 0 }
    /^\[/ { 
        current_post++;
        print $0;
        if (current_post == post_number) {
            print "    -- Comments:";
            print comment;
        }
        next;
    }
    { print }
' "$POSTS_FILE" > "$POSTS_FILE.tmp" && mv "$POSTS_FILE.tmp" "$POSTS_FILE"

echo "Your comment has been added successfully!"
