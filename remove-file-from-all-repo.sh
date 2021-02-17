#!/bin/bash

usage="usage: remove-file-from-all-functions.sh [file_name] [branch_name] [pr_title] [pr_description]
       where:
       - file_name: the name of the file to remove
       - branch_name: the name of the branch to create
       - pr_title: the PR title
       - pr_description: the PR description
      "

if [[ ! $# -eq 4 ]] ; then
    echo "$usage"
    exit 1
fi

inputs=( "$@" )
file_name="${inputs[0]}"
branch_name="${inputs[1]}"
pr_title="${inputs[2]}"
pr_description="${inputs[3]}"

echo "Removing file(s).."
cat "io-functions-list.txt"  | xargs -I{} scripts/remove-file-from-repo.sh {}  "$file_name" . "$branch_name" "$pr_title" "$pr_description" 
