#!/usr/bin/env bash

set -e

GITHUB_TOKEN=$1
FILES=$2

echo "Formatting filenames..."
EXPECTED_FILES="$(printf $(echo ${FILES} | sed 's| ||g' | sed 's/,/|/g'))"

echo "Checking changes for \"${EXPECTED_FILES}\"... "
CHANGED_FILES=$(git diff --diff-filter=ACM --name-only | grep -E "(${EXPECTED_FILES})" || true)

if [[ -z ${CHANGED_FILES} ]]; then
  echo "::set-output name=files_changed::false"
  exit 0;
else
  echo "::set-output name=files_changed::true"
  exit 0;
fi
