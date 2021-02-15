#!/bin/bash

# -------------------------------------------------------
# A shell script to add  file to a repo and make a PR
# -------------------------------------------------------


usage="usage: add-file-to-repo [github_repo] [file_name] [from_folder] [to_folder] [branch_name] [pr_title] [pr_description]
    where:
    - github_repo: github repo where file needs to be added
    - file_name: the name of the file to add
    - from_folder: the path of the folder where the file is present
    - to_folder: the path of the folder where the file has to be added
    - branch_name: the name of the branch to create
    - pr_title: the title of the PR
    - pr_description: the description of the PR
"

if [[ ! $# -eq 7 ]] ; then
    echo "$usage"
    exit 1
fi


inputs=( "$@" )
get_input()
{
    case $1 in
     "github_repo")
        echo "${inputs[0]}"
        ;;
     "file_name")
        echo "${inputs[1]}"
        ;;
     "from_folder")
        echo "${inputs[2]}"
        ;;
     "to_folder")
        echo "${inputs[3]}"
        ;;
     "branch_name")
        echo "${inputs[4]}"
        ;;
     "pr_title")
        echo "${inputs[5]}"
        ;;
     "pr_description")
        echo "${inputs[6]}"
        ;;

     esac
}


repo="$(get_input "github_repo")"
branch_name="$(get_input "branch_name")"
file_name="$(get_input "file_name")"
from_folder="$(get_input "from_folder")"
to_folder="$(get_input "to_folder")"
pr_title="$(get_input "pr_title")"
pr_description="$(get_input "pr_description")"

git clone "git@github.com:pagopa/$repo.git"

cp "$from_folder/$file_name" "$repo/$to_folder/$file_name"

cd "$repo" || exit 1;
git checkout -b "$branch_name"

git add "$to_folder/$file_name"
git commit -m "$pr_title"

git push origin "$branch_name"
hub pull-request -m "$pr_title" -m "$pr_description"

pr_num=$(hub pr list | grep "$pr_title" | awk '{print $1}' | sed 's/#//')
echo "PR #$pr_num has been created in repo $repo"

#hub pr show "$pr_num"

cd ..
rm -rf "$repo"
