#!/bin/bash
# Script to delete a comment from a post

POSTS_FILE=~/cli_social_network/posts.txt
LOGGED_IN_USER_FILE=~/cli_social_network/logged_in_user

# Check if the user is logged in
if [ ! -f "$LOGGED_IN_USER_FILE" ]; then
    echo "Error: You must log in to delete comments."
    exit 1
fi

logged_in_user=$(cat "$LOGGED_IN_USER_FILE")

# Ask for the post number to delete a comment from
echo "Enter the post number you want to delete a comment from: "
read post_number

# Validate input
if ! [[ "$post_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a valid post number."
    exit 1
fi

# Display the comments for the selected post
echo "Here is the selected post and its comments:"
comments=$(awk -v post_number="$post_number" '
    BEGIN { current_post = 0; in_comments = 0; comment_number = 1 }
    /^\[/ { 
        current_post++;
        if (current_post == post_number) {
            print $0;
            in_comments = 1;
            next;
        }
        in_comments = 0;
    }
    in_comments && /^[ \t]+\[/ { 
        printf "        %d  %s\n", comment_number++, $0;
    }
' "$POSTS_FILE")

if [ -z "$comments" ]; then
    echo "Error: No comments found for the specified post."
    exit 1
fi

echo "$comments"

# Ask for the comment number to delete
echo "Enter the comment number you want to delete: "
read comment_number

# Validate input
if ! [[ "$comment_number" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a valid comment number."
    exit 1
fi

# Check if the comment number exists
total_comments=$(echo "$comments" | grep -c "^[ \t]*[0-9]")
if [ "$comment_number" -lt 1 ] || [ "$comment_number" -gt "$total_comments" ]; then
    echo "Error: No such comment exists for the specified post."
    exit 1
fi

# Check if the logged-in user is the author of the comment
comment_author=$(awk -v post_number="$post_number" -v comment_number="$comment_number" '
    BEGIN { current_post = 0; in_comments = 0; comment_count = 0 }
    /^\[/ { 
        current_post++;
        if (current_post == post_number) {
            in_comments = 1;
            next;
        }
        in_comments = 0;
    }
    in_comments && /^[ \t]+\[/ { 
        comment_count++;
        if (comment_count == comment_number) {
            # Extract the username from the comment
            if (match($0, /^[ \t]+\[[^]]+\] ([^:]+):/, matches)) {
                print matches[1];
                exit;
            }
        }
    }
' "$POSTS_FILE")

if [ "$comment_author" != "$logged_in_user" ]; then
    echo "Error: You can only delete your own comments."
    exit 1
fi

# Delete the selected comment from the post
awk -v post_number="$post_number" -v comment_number="$comment_number" '
    BEGIN { current_post = 0; in_comments = 0; comment_count = 0 }
    /^\[/ { 
        current_post++;
        print $0;  # Print the post
        if (current_post == post_number) {
            in_comments = 1;
            next;
        }
        in_comments = 0;
    }
    in_comments && /^[ \t]+\[/ { 
        comment_count++;
        if (comment_count == comment_number) {
            next;  # Skip the selected comment
        }
        print $0;  # Print other comments
    }
' "$POSTS_FILE" > "$POSTS_FILE.tmp" && mv "$POSTS_FILE.tmp" "$POSTS_FILE"

# Confirm the comment deletion
if [ $? -eq 0 ]; then
    echo "The comment has been deleted successfully!"
else
    echo "Error: Failed to delete the comment. Please try again."
fi
