#!/bin/bash

set -e

# change to the directory in which this script is located
pushd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 || exit 1

# shellcheck disable=SC1091
source "$HOME/.chouti-shell/lib.sh" || exit 1

# ===------ BEGIN ------===

# OVERVIEW: Build products

if ! command -v swift-build &> /dev/null; then
  echo "🛑 swift-build command not found"
  exit 1
fi

# if ./Products directory exits
if [ -d "./Products" ]; then
  # if has files in ./Products directory
  if [ "$(ls -A ./Products)" ]; then
    # prompt "Do you want to continue?" "reply=\"y\"" "reply=\"n\"" "reply=\"n\""
    reply=""
    prompt "./Products is not empty, do you want to clean it up?" "reply=\"y\"" "reply=\"n\"" "reply=\"n\""
    if [ "$reply" == "y" ]; then
      # remove all files in ./Products directory
      rm -rf ./Products/*
    else
      echo "🛑 abort"
      exit 1
    fi
  fi
fi

# make arm64 binary
swift-build --arch arm64
if [ $? -ne 0 ]; then
  echo "🛑 failed to make binary"
  exit 1
fi

# renmae ./Products/swiftformat to ./Products/swiftformat-arm64
mv ./Products/swiftformat ./Products/swiftformat-arm64

# zip the file
cd ./Products || exit 1
zip -r ./swiftformat-arm64.zip ./swiftformat-arm64
cd .. || exit 1

# make x86_64 binary
swift-build --arch x86_64
if [ $? -ne 0 ]; then
  echo "🛑 failed to make binary"
  exit 1
fi

# rename ./Products/swiftformat to ./Products/swiftformat-x86_64
mv ./Products/swiftformat ./Products/swiftformat-x86_64

# zip the file
cd ./Products || exit 1
zip -r ./swiftformat-x86_64.zip ./swiftformat-x86_64
cd .. || exit 1

# combine arm64 and x86_64 binary
lipo -create -output ./Products/swiftformat ./Products/swiftformat-arm64 ./Products/swiftformat-x86_64

# zip the file
cd ./Products || exit 1
zip -r ./swiftformat.zip ./swiftformat
cd .. || exit 1

# ===------ END ------===

# return to whatever directory we were in when this script was run
popd >/dev/null 2>&1 || exit 0
