#!/usr/bin/env bash

set -e

git remote set-url origin "https://${INPUT_TOKEN}@github.com/${GITHUB_REPOSITORY}"

CHANGED_FILES=() 

for path in ${INPUT_FILES}
do
   echo "Checking for file changes: \"${path}\"..."
   MODIFIED_FILE=$(git diff --diff-filter=ACMUXTR --name-only | grep -E "(${path})" || true)
   
   if [[ -z $MODIFIED_FILE ]]; then
     # Find unstaged changes
     MODIFIED_FILE=$(git status --porcelain | awk '{ print $2 }' | grep -E "(${path})" || true)
   fi
   
   if [[ -n ${MODIFIED_FILE} ]]; then
     echo "Found uncommited changes at: ${path}"
     CHANGED_FILES+=("${path}")
   else
     echo "No changes found at: ${path}"
   fi
done

if [[ -z ${CHANGED_FILES} ]]; then
  echo "::set-output name=files_changed::false"
else
  echo "::set-output name=files_changed::true"
  echo "::set-output name=changed_files::${CHANGED_FILES}"
fi

exit 0;
