#!/bin/sh

# git-list-repo-states [-f] <repo-container-directory>


fetch=""
path=""
if [ "$#" -eq "0" ]; then
    fetch=""
    path="."
elif [ "$#" -eq "1" ]; then
    if [ "$1" = "-f" ]; then
        fetch="true"
        path="."
    else
        fetch=""
        path="$1"
    fi
elif [ "$#" -eq "2" ]; then
    if [ "$1" = "-f" ]; then
        fetch="true"
        path="$2"
    else
        fetch=""
        path="$1"
    fi
else
    echo "$0: Error: Too much input parameters"
    exit 1
fi


for repo in "$path"/*/; do
    if [ -d "$repo/.git" ]; then
        echo "----------------------------"
        echo "$repo"
        if [ "$fetch" = "true" ]; then
            git -C "$repo" fetch --all
        fi
        git -C "$repo" log --all --simplify-by-decoration --pretty=format:"%C(auto)%h %d"
    fi
done
