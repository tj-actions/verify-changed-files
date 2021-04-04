#!/usr/bin/env bash

set -e

CHANGED_FILES=() 

for path in ${INPUT_FILES}
do
   echo "Checking for file changes: \"${path}\"..."
   MODIFIED_FILE=$(git diff --diff-filter=ACMUXTR --name-only | grep -E "(${path})" || true)
   if [[ -n ${MODIFIED_FILE} ]]; then
     echo "Found uncommited changes at: ${path}"
     CHANGED_FILES+=("${path}")
   fi
done

if [[ -z ${CHANGED_FILES} ]]; then
  echo "::set-output name=files_changed::false"
else
  echo "::set-output name=files_changed::true"
  echo "::set-output name=changed_files::${CHANGED_FILES}"
fi

exit 0;
