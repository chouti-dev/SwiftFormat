#!/bin/bash

currentDir=$(pwd) # store current dir for later use.
cd $(dirname $0) # cd to the command dir.

# --- Start ---

# 0) prepare
echo "➡️  verify upstream origin is set"
# check git remote
# https://stackoverflow.com/a/9622518/3164091
git ls-remote "git@github.com:nicklockwood/SwiftFormat.git" > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
  echo "🛑 no upstream origin"
  exit 1;
fi

echo "➡️  git pull"
git fetch git@github.com:nicklockwood/SwiftFormat.git --tags
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
git merge $tagToMerge --no-edit
if [ $? -ne 0 ]; then
  echo "🛑 merge failed"
  exit 1
fi

# 3) run test
echo "➡️  run tests"
xcodebuild -project SwiftFormat.xcodeproj -scheme "SwiftFormat (Framework)" -sdk macosx clean build test | xcbeautify
if [ $? -ne 0 ]; then
  echo "🛑 test failed"
  exit 1
fi

# 4) create a new tag
newTag="$tagToMerge-chouti"
while true; do
  read -p "$(echo -e '➡️  'create a new tag ${COLOR_GREEN}$newTag${COLOR_RESET}'?' '(y/n) ')" yn
  case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
done

git tag $newTag
if [ $? -ne 0 ]; then
  echo "🛑 creat tag failed"
  exit 1
fi

# 5) push new tag
while true; do
  read -p "$(echo -e '➡️  'push new tag ${COLOR_GREEN}$newTag${COLOR_RESET} to origin'?' '(y/n) ')" yn
  case $yn in
      [Yy]* ) break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
  esac
done
git push origin $newTag
if [ $? -ne 0 ]; then
  echo "🛑 push tag failed"
  exit 1
fi

# 6) open web to create a new release
open https://github.com/chouti-dev/SwiftFormat/releases/new?tag=$newTag

# --- End ---

cd $currentDir # restore the dir back.
