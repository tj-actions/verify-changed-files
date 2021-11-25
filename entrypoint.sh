#!/usr/bin/env bash

set -e

git config --local core.autocrlf "$INPUT_AUTO_CRLF"

IFS=" " read -r -a ALL_FILES <<< "$(echo "${INPUT_FILES[@]}" | sort -u | tr "\n" " ")"

FILES=$(echo "${ALL_FILES[*]}" | awk '{gsub(/ /,"\n"); print $0;}' | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

echo "Checking for file changes: \"${FILES}\"..."

TRACKED_FILES=$(git diff --diff-filter=ACMUXTR --name-only | grep -E "(${FILES})" | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

# Find untracked changes
UNTRACKED_FILES=$(git ls-files --others --exclude-standard | grep -E "(${FILES})" | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

CHANGED_FILES=""

if [[ -n "$TRACKED_FILES" && -n "$UNTRACKED_FILES" ]]; then
  CHANGED_FILES="$TRACKED_FILES|$UNTRACKED_FILES"
elif [[ -n "$TRACKED_FILES" && -z "$UNTRACKED_FILES" ]]; then
  CHANGED_FILES="$TRACKED_FILES"
elif [[ -n "$UNTRACKED_FILES" && -z "$TRACKED_FILES" ]]; then
  CHANGED_FILES="$UNTRACKED_FILES"
fi

CHANGED_FILES=$(echo "$CHANGED_FILES"  | awk '{gsub(/\|/,"\n"); print $0;}' | sort -u | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

if [[ -n "$CHANGED_FILES" ]]; then
  echo "Found uncommited changes"
  echo "---------------"
  printf '%s\n' "$(echo "$CHANGED_FILES" | awk '{gsub(/\|/," "); print $0;}')"
  echo "---------------"
  echo "::set-output name=files_changed::true"
  echo "::set-output name=changed_files::$CHANGED_FILES"
else
  echo "No changes found."
  echo "::set-output name=files_changed::false"
fi

exit 0;
