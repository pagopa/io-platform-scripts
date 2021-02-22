#!/bin/bash

# -------------------------------------------------------
# A shell script to add  file to a repo and make a PR
# -------------------------------------------------------


usage="usage: fix-dependencies [github_repo] [branch_name] [pr_title] [pr_description]
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


repoFolder="/tmp/$repo-$(date +"%s")" # repo name + timestamp
git clone "git@github.com:pagopa/$repo.git" "$repoFolder"
cd "$repoFolder"

git checkout -b "$branch_name"

# --------------------------------------
# Custom code
# --------------------------------------

out_dir="$(jq -r ".compilerOptions.outDir" tsconfig.json)"

# Add files/folders to exclude from bu ild
echo "$(jq ".exclude= [\"__mocks__\", \"$out_dir\", \"node_modules\", \"**/__tests__/*\", \"Dangerfile.ts\"]" tsconfig.json)" > tsconfig.json


# Check missing dependencies and add them
yarn install --frozen-lockfile
yarn build

npx dependency-check package.json --no-dev --missing ./$out_dir/**/*.js >> check_dep 2>&1
missing_dependencies="$(grep "Fail" check_dep | sed "s/Fail\\! Dependencies not listed in package.json: *//g")"

if [ -n "$missing_dependencies" ];
then
   missing_dependencies_array=(${missing_dependencies//,/ })
   printf '%s\n' "${missing_dependencies_array[@]}" | xargs -I{} yarn add {}
else
   echo "No missing dependency to add"
fi

rm check_dep
# End check missing dependencies and add them

# Add postbuild check
echo "$(jq ".scripts.postbuild= \"npx dependency-check package.json --no-dev --missing ./$out_dir/**/*.js\"" package.json)" > package.json


yarn build

git status

git add package.json
git add tsconfig.json
git add yarn.lock

# --------------------------------------
# End Custom code
# --------------------------------------

git commit -m "$pr_title"

git push origin "$branch_name"
hub pull-request -m "$pr_title" -m "$pr_description" -d

pr_num=$(hub pr list | grep "$pr_title" | awk '{print $1}' | sed 's/#//')
echo "PR #$pr_num has been created in repo $repo"
