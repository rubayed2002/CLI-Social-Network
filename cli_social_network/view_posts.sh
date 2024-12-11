#!/bin/bash
# Script to view all posts along with their comments

POSTS_FILE=~/cli_social_network/posts.txt

# Check if posts file exists and is not empty
if [ ! -f "$POSTS_FILE" ] || [ ! -s "$POSTS_FILE" ]; then
    echo "No posts available!"
    exit 0
fi

# Display all posts with comments
echo "Here are all the posts:"
awk '
    BEGIN { current_post = 0; in_comments = 0; }
    /^\[/ { 
        # Print the post number and content
        current_post++;
        printf "%d  %s\n", current_post, $0;
        in_comments = 0;
    }
    /^    -- Comments:/ { 
        # Print the comment section heading
        print $0;
        in_comments = 1;
    }
    /^[ \t]+\[/ && in_comments == 1 { 
        # Print each individual comment under the "Comments" section
        print "        " $0;
    }
' "$POSTS_FILE"

echo "You can comment or delete a comment next."
echo "Choose an option:"
echo "1. Comment on a post"
echo "2. Delete a comment"
echo "3. Return to Main Menu"
echo "4. Exit"
read action

case $action in
    1)
        ./comment_post.sh
        ;;
    2)
        ./delete_comment.sh
        ;;
    3)
        ./main.sh
        ;;
    4)
        exit 0
        ;;
    *)
        echo "Invalid option. Returning to main menu."
        ./main.sh
        ;;
esac
