#!/bin/bash

repo_template="io-functions-template"

usage="usage: copy-file-from-template-to-all-functions.sh [file_name] [branch_name] [pr_title] [pr_description]
       where:
       - file_name: the name of the file to add
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

echo "Cloning template repository.."
git clone "git@github.com:pagopa/$repo_template.git"

echo "Adding file(s).."
cat "io-functions-list.txt"  | xargs -I{} scripts/add-file-to-repo.sh {}  "$file_name" "$repo_template" . "$branch_name" "$pr_title" "$pr_description" 

echo "Removing template repository.."
rm -rf "$repo_template"
