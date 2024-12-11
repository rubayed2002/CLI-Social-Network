#!/bin/bash
# Script to delete a post along with its comments

POSTS_FILE=~/cli_social_network/posts.txt
LOGGED_IN_USER_FILE=~/cli_social_network/logged_in_user

# Check if the user is logged in
if [ ! -f "$LOGGED_IN_USER_FILE" ]; then
    echo "Error: You must log in to delete a post."
    exit 1
fi

logged_in_user=$(cat "$LOGGED_IN_USER_FILE")

# Ensure posts.txt exists and is not empty
if [ ! -f "$POSTS_FILE" ] || [ ! -s "$POSTS_FILE" ]; then
    echo "No posts available to delete!"
    exit 0
fi

# Display all posts with numbers (excluding comments)
echo "Here are all the posts:"
awk '
    BEGIN { post_number = 1 }
    /^\[/ {
        printf "%5d  %s\n", post_number++, $0;
    }
' "$POSTS_FILE"

# Prompt the user to enter the post number to delete
echo "Enter the post number to delete: "
read post_number

# Validate input
if ! [[ "$post_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a valid post number."
    exit 1
fi

# Get the selected post's content
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

# Check if the post exists
if [ -z "$selected_post" ]; then
    echo "Invalid post number. No such post exists."
    exit 1
fi

# Check if the logged-in user is the author of the post
post_author=$(echo "$selected_post" | sed -n 's/^\[\([^]]*\)\] \(.*\): .*/\2/p')
if [ "$post_author" != "$logged_in_user" ]; then
    echo "Error: You can only delete your own posts."
    exit 1
fi

# Confirm deletion
echo "You are about to delete the following post:"
echo "$selected_post"
echo "Are you sure? (y/n)"
read confirm

if [ "$confirm" != "y" ]; then
    echo "Deletion cancelled."
    exit 0
fi

# Delete the post and associated comments
awk -v post_number="$post_number" '
    BEGIN { current_post = 0; in_comment_section = 0 }
    /^\[/ {
        current_post++;
        if (current_post == post_number) {
            in_comment_section = 1;  # Start skipping comments
            next;
        }
    }
    in_comment_section && /^[ \t]+\[/ {
        next;  # Skip comments for the selected post
    }
    /^[ \t]+\[/ {
        in_comment_section = 0;  # End skipping comments
    }
    { print }
' "$POSTS_FILE" > "$POSTS_FILE.tmp" && mv "$POSTS_FILE.tmp" "$POSTS_FILE"

echo "Post and its associated comments have been deleted successfully!"
