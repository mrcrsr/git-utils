#!/bin/sh

for repo in */; do
    if [ -d "$repo/.git" ]; then
        echo "----------------------------"
        echo "$repo"
        timeout 5 git -C "$repo" fetch --all
    fi
done
