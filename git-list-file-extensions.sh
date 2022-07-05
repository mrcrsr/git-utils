#!/bin/sh

# Lists all different file extensions for a given directory inluding all subdirectories.
#
# It's used to obtain the different file types of a git repository
# to be able to configurate the repositorie's .gitignore file and .gitattribute file


search_path="$1"

if [ -z "$search_path" ]; then
    search_path="."
fi

# Files with dot
printf "Files with extension:\n"
files_with_dot="$(find "$search_path" -type f | sed -e 's/\.\///' | sed -e 's/^.*\///' | grep -e "\." | sed 's/^.*\././' | sort | uniq)"
echo "$files_with_dot"

# Files without dot
printf "\nFiles without extension:\n"
files_without_dot="$(find "$search_path" -type f | sed -e 's/\.\///' | sed -e 's/^.*\///' | grep -v -e "\." | sort | uniq)"
echo "$files_without_dot"


