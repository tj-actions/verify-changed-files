#!/usr/bin/env bash

set -e

FILES=$2

CHANGED_FILES=() 

for path in ${FILES}
do
   echo "Checking for file changes: \"${path}\"..."
   MODIFIED_FILE=$(git diff --diff-filter=ACM --name-only | grep -E "(${path})" || true)
   if [[ -n ${MODIFIED_FILE} ]]; then
     CHANGED_FILES+=("${path}")
   fi
done

if [[ -z ${CHANGED_FILES} ]]; then
  echo "::set-output name=files_changed::false"
  exit 0;
else
  echo "::set-output name=files_changed::true"
  exit 0;
fi
