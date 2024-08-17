#!/bin/bash

currentDir=$(pwd) # store current dir for later use.
cd $(dirname $0) # cd to the command dir.

# --- Start ---

echo "➡️  run tests"
xcodebuild -project SwiftFormat.xcodeproj -scheme "SwiftFormat (Framework)" -sdk macosx clean build test
if [ $? -ne 0 ]; then
  echo "🛑 test failed"
  exit 1
fi

# --- End ---

cd $currentDir # restore the dir back.
