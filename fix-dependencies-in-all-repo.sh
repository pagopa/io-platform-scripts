#!/bin/bash

usage="usage: fix-dependencies-in-all-repo.sh [branch_name] [pr_title] [pr_description]
       where:
       - branch_name: the name of the branch to create
       - pr_title: the PR title
       - pr_description: the PR description
      "

if [[ ! $# -eq 3 ]] ; then
    echo "$usage"
    exit 1
fi

inputs=( "$@" )
branch_name="${inputs[0]}"
pr_title="${inputs[1]}"
pr_description="${inputs[2]}"

cat "io-functions-list.txt"  | xargs -I{} scripts/fix-dependencies.sh {} "$branch_name" "$pr_title" "$pr_description" 
