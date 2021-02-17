#!/bin/bash

# -------------------------------------------------------
# A shell script to remove  file to a repo and make a PR
# -------------------------------------------------------


usage="usage: remove-file-from-repo [github_repo] [file_name] [from_folder] [branch_name] [pr_title] [pr_description]
    where:
    - github_repo: github repo where file needs to be removed
    - file_name: the name of the file to remove
    - from_folder: the path of the folder where the file is present
    - branch_name: the name of the branch to create
    - pr_title: the title of the PR
    - pr_description: the description of the PR
"

if [[ ! $# -eq 6 ]] ; then
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
     "branch_name")
        echo "${inputs[3]}"
        ;;
     "pr_title")
        echo "${inputs[4]}"
        ;;
     "pr_description")
        echo "${inputs[5]}"
        ;;

     esac
}


repo="$(get_input "github_repo")"
branch_name="$(get_input "branch_name")"
file_name="$(get_input "file_name")"
from_folder="$(get_input "from_folder")"
pr_title="$(get_input "pr_title")"
pr_description="$(get_input "pr_description")"

git clone "git@github.com:pagopa/$repo.git"
cd "$repo" || exit 1;
git checkout -b "$branch_name"

# --------------------------------------
# Custom code
# --------------------------------------

sh -c "/bin/rm -f $from_folder/$file_name"

# --------------------------------------
# / End Custom code
# --------------------------------------


git status
git add "$from_folder/$file_name"
git commit -m "$pr_title"

git push origin "$branch_name"
hub pull-request -m "$pr_title" -m "$pr_description" -d

pr_num=$(hub pr list | grep "$pr_title" | awk '{print $1}' | sed 's/#//')
echo "PR #$pr_num has been created in repo $repo"

cd ..
rm -rf "$repo"