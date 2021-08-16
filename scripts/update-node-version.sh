#!/bin/bash

# -------------------------------------------------------
# A shell script to add  file to a repo and make a PR
# -------------------------------------------------------


usage="usage: fix-dependencies [github_repo] [branch_name] [pr_title] [pr_description] [node_version]
    where:
    - github_repo: github repo where file needs to be added
    - branch_name: the name of the branch to create
    - pr_title: the title of the PR
    - pr_description: the description of the PR
    - node_version: the version to update to
"

if [[ ! $# -eq 5 ]] ; then
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
     "branch_name")
        echo "${inputs[1]}"
        ;;
     "pr_title")
        echo "${inputs[2]}"
        ;;
     "pr_description")
        echo "${inputs[3]}"
        ;;
     "node_version")
        echo "${inputs[4]}"
        ;;
     esac
}

repo="$(get_input "github_repo")"
branch_name="$(get_input "branch_name")"
pr_title="$(get_input "pr_title")"
pr_description="$(get_input "pr_description")"
node_version="$(get_input "node_version")"


repoFolder="/tmp/$repo-$(date +"%s")" # repo name + timestamp
git clone "git@github.com:pagopa/$repo.git" "$repoFolder"
cd "$repoFolder"

git checkout -b "$branch_name"

# --------------------------------------
# Custom code
# --------------------------------------

# update node version
echo $node_version > .node-version #using nodenv
echo $node_version > .nvmrc #using nvm

git add .
git commit -m "update Node version to $node_version"

# force dependency
rm yarn.lock
yarn install

git add yarn.lock
git commit -m "update dependencies"

# --------------------------------------
# End Custom code
# --------------------------------------

git push origin "$branch_name"
hub pull-request -m "$pr_title" -m "$pr_description" -d

pr_num=$(hub pr list | grep "$pr_title" | awk '{print $1}' | sed 's/#//')
echo "PR #$pr_num has been created in repo $repo"
