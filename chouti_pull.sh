#!/bin/bash

currentDir=$(pwd) # store current dir for later use.
cd $(dirname $0) # cd to the command dir.

# --- Start ---

# 0) prepare
echo "➡️  git pull"
git pull

# 1) get the tag to merge
# Getting latest tag on git repository
# https://gist.github.com/rponte/fdc0724dd984088606b0
tagToMerge=$(git describe --tags `git rev-list --tags --max-count=1`)

# 1) confirm before merge
currentBranch=$(git-show-current-branch)

# How to handle yes/no
# https://www.shellhacks.com/yes-no-bash-script-prompt-confirmation/
while true; do
  read -p "$(echo -e '➡️  'will merge tag: ${COLOR_GREEN}$tagToMerge${COLOR_RESET} to branch: ${COLOR_GREEN}$currentBranch${COLOR_RESET}, continue'?' '(y/n) ')" yn
  case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
done

# 2) merge
echo "➡️  git merge $tagToMerge --no-edit"
git merge tagToMerge --no-edit

# 3) run test
# echo "➡️  run tests"
# xcodebuild -project SwiftFormat.xcodeproj -scheme "SwiftFormat (Framework)" -sdk macosx clean build test | xcbeautify
if [ $? -ne 0 ]; then
  echo "🛑 test failed"
  return
fi

# 4) create a new tag
newTag="chouti-$tagToMerge"
while true; do
  read -p "$(echo -e '➡️  'create a new tag ${COLOR_GREEN}$newTag${COLOR_RESET}'?' '(y/n) ')" yn
  case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
done

git tag $newTag

# --- End ---

cd $currentDir # restore the dir back.
