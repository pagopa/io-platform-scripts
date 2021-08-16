#!/bin/bash

usage="usage: fix-dependencies-in-all-repo.sh [node_version]
       where:
       - branch_name: the name of the branch to create
       - pr_title: the PR title
       - pr_description: the PR description
      "

if [[ ! $# -eq 1 ]] ; then
    echo "$usage"
    exit 1
fi

inputs=( "$@" )
node_version="${inputs[0]}"


title="Update Node to $node_version"
branch="update-node-version"


# cat "io-functions-list.txt"  | xargs -I{} scripts/fix-dependencies.sh {} "$branch_name" "$pr_title" "$pr_description" 

#repo="io-functions-admin"; id="IP-344"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#repo="io-functions-app"; id="IP-345"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#repo="io-backend"; id="IP-346"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#repo="io-functions-assets"; id="IP-347"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#TODO repo="io-functions-backoffice"; id="IP-348"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#TODO repo="io-functions-bonus"; id="IP-349"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#TODO repo="io-functions-bonusapi"; id="IP-350"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#repo="io-functions-public"; id="IP-351"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
repo="io-functions-eucovidcerts"; id="IP-352"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
repo="io-functions-template"; id="IP-353"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
repo="io-template-typescript"; id="IP-354"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
repo="io-functions-commons"; id="IP-355"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
repo="ts-commons"; id="IP-356"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#repo="io-developer-portal-frontend"; id="IP-357"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#repo="io-developer-portal-backend"; id="IP-358"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &
#repo="io-spid-commons"; id="IP-359"; scripts/update-node-version.sh $repo "$id--$branch" "[#$id] $title" "$title" "$node_version" &

wait
