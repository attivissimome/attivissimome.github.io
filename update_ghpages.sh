#!/bin/bash -e

SOURCE_BRANCH=develop
PUBLISH_BRANCH=master
 
if git status --porcelain 2>/dev/null | grep -q .; then
  echo "Working copy is dirty" >&2
  exit 1
fi
 
# task for release
grunt release
 
git checkout $PUBLISH_BRANCH
 
# remove all folders expcept dist (and all dotfiles)
ls -1 | grep -v -E 'dist' | xargs rm -R

# copy all files from dist to root
cd dist && cp -rf * ../
cd ../ && rm -rf dist
 
# add all needed files and push it into origin/gh-pages
git add -A
git commit -m "Publish commit"
git push origin $PUBLISH_BRANCH
 
git checkout $SOURCE_BRANCH
