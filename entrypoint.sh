#!/usr/bin/env bash

set -e

SERVER_URL=$(echo "$GITHUB_SERVER_URL" | awk -F/ '{print $3}')

git remote add temp_verify_changed_files "https://${INPUT_TOKEN}@${SERVER_URL}/${GITHUB_REPOSITORY}"

CHANGED_FILES=() 

for path in ${INPUT_FILES}
do
   echo "Checking for file changes: \"${path}\"..."
   # shellcheck disable=SC2207
   CHANGED_FILES+=($(git diff --diff-filter=ACMUXTR --name-only | grep -E "(${path})" || true))
   # Find unstaged changes
   # shellcheck disable=SC2207
   CHANGED_FILES+=($(git status --porcelain | awk '{ print $2 }' | grep -E "(${path})" || true))
done

IFS=" " read -r -a UNIQUE_CHANGED_FILES <<< "$(echo "${CHANGED_FILES[@]}" | tr " " "\n" | sort -u | tr "\n" " ")"

if [[ -n "${UNIQUE_CHANGED_FILES[*]}" ]]; then
  echo "Found uncommited changes"
  echo "---------------"
  printf '%s\n' "${UNIQUE_CHANGED_FILES[@]}"
  echo "---------------"
else
  echo "No changes found."
fi

if [[ -z "${UNIQUE_CHANGED_FILES[*]}" ]]; then
  echo "::set-output name=files_changed::false"
else
  echo "::set-output name=files_changed::true"
  echo "::set-output name=changed_files::${UNIQUE_CHANGED_FILES[*]}"
fi

git remote remove temp_verify_changed_files

exit 0;
