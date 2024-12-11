#!/bin/bash
# Main Menu for CLI Social Network

LOGGED_IN_USER_FILE=~/cli_social_network/logged_in_user

while true; do
    if [ -f "$LOGGED_IN_USER_FILE" ]; then
        # Logged-In Menu
        logged_in_user=$(cat "$LOGGED_IN_USER_FILE")
        echo "Welcome, $logged_in_user!"
        echo "1. Create a Post"
        echo "2. Delete a Post"
        echo "3. View All Posts"
        echo "4. Log Out"
        echo "5. Exit"
        echo "Choose an option: "
        read option

        case $option in
            1)
                ./create_post.sh
                ;;
            2)
                ./delete_post.sh
                ;;
            3)
                ./view_posts.sh
                ;;
            4)
                ./logout.sh
                ;;
            5)
                echo "Exiting. Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid option! Please try again."
                ;;
        esac
    else
        # Initial Menu
        echo "Welcome to ConnecShell!"
        echo "1. Log In"
        echo "2. Register"
        echo "3. Exit"
        echo "Choose an option: "
        read option

        case $option in
            1)
                ./login.sh
                ;;
            2)
                ./register.sh
                ;;
            3)
                echo "Exiting. Goodbye!"
                exit 0
                ;;
            *)
                echo "Invalid option! Please try again."
                ;;
        esac
    fi
done
