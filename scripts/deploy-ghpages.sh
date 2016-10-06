#!/bin/sh
# ideas used from https://gist.github.com/motemen/8595451

# From https://github.com/eldarlabs/ghpages-deploy-script/blob/master/scripts/deploy-ghpages.sh
# Used with their MIT license https://github.com/eldarlabs/ghpages-deploy-script/blob/master/LICENSE
# abort the script if there is a non-zero error

echo "one"
set -e

echo "two"
# show where we are on the machine
pwd
echo "three"
remote=$(git config remote.origin.url)
echo "remote"
echo remote
echo "four"

siteSource="$1"
echo "five"
echo "siteSource"
echo siteSource
if [ ! -d "$siteSource" ]
then
    echo "Usage: $0 <site source dir>"
    exit 1
fi
echo "six"

# make a directory to put the gp-pages branch
mkdir gh-pages-branch
echo "seven"
cd gh-pages-branch
echo "eight"
# now lets setup a new repo so we can update the gh-pages branch
echo "nine"
git config --global user.email "$GH_EMAIL" > /dev/null 2>&1
echo "ten"
git config --global user.name "$GH_NAME" > /dev/null 2>&1
echo "eleven"
git init
echo "twelve"
git remote add --fetch origin "$remote"
echo "thirteen"


# switch into the the gh-pages branch
if git rev-parse --verify origin/gh-pages > /dev/null 2>&1
then
    git checkout gh-pages
    # delete any old site as we are going to replace it
    # Note: this explodes if there aren't any, so moving it here for now
    git rm -rf .
else
    git checkout --orphan gh-pages
fi

# copy over or recompile the new site
cp -a "../${siteSource}/." .

# stage any changes and new files
git add -A
# now commit, ignoring branch gh-pages doesn't seem to work, so trying skip
git commit --allow-empty -m "Deploy to GitHub pages [ci skip]"
# and push, but send any output to /dev/null to hide anything sensitive
git push --force --quiet origin gh-pages > /dev/null 2>&1

# go back to where we started and remove the gh-pages git repo we made and used
# for deployment
cd ..
rm -rf gh-pages-branch

echo "Finished Deployment!"

