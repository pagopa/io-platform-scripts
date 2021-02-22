#!/bin/bash

# -------------------------------------------------------
# A shell script to add  file to a repo and make a PR
# -------------------------------------------------------


usage="usage: update-package-json [github_repo] [branch_name] [pr_title] [pr_description]
    where:
    - github_repo: github repo where file needs to be added
    - branch_name: the name of the branch to create
    - pr_title: the title of the PR
    - pr_description: the description of the PR
"

if [[ ! $# -eq 4 ]] ; then
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

     esac
}


repo="$(get_input "github_repo")"
branch_name="$(get_input "branch_name")"
pr_title="$(get_input "pr_title")"
pr_description="$(get_input "pr_description")"

git clone "git@github.com:pagopa/$repo.git"
cd "$repo" || exit 1;
git checkout -b "$branch_name"

# --------------------------------------
# Custom code
# --------------------------------------

package_name=$(cat "package.json" | jq -r '.name')
has_org=$(cat "package.json" | jq '.name | contains("@pagopa/")')

echo "--> Repo $repo contains @pagopa: $has_org (package name: $package_name)"

if [ $has_org == false ]; 
then 
   echo "Aggiungere @pagopa a $repo"
   echo "$(jq ".name = \"@pagopa/$package_name\"" package.json)" > package.json

   git add package.json

   # --------------------------------------
   # / End Custom code
   # --------------------------------------

   git commit -m "$pr_title"

   git push origin "$branch_name"
   hub pull-request -m "$pr_title" -m "$pr_description"

   pr_num=$(hub pr list | grep "$pr_title" | awk '{print $1}' | sed 's/#//')
   echo "PR #$pr_num has been created in repo $repo"

fi


cd ..
rm -rf "$repo"
