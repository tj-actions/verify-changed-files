#!/usr/bin/env bash

set -e

git config --local core.autocrlf "$INPUT_AUTO_CRLF"

IFS=" " read -r -a ALL_FILES <<< "$(echo "${INPUT_FILES[@]}" | sort -u | tr "\n" " ")"

FILES=$(echo "${ALL_FILES[*]}" | awk '{gsub(/ /,"\n"); print $0;}' | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

echo "Checking for file changes: \"${FILES}\"..."

STAGED_FILES=$(git diff --diff-filter=ACMUXTR --name-only | grep -E "(${FILES})" | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

# Find unstaged changes
UNSTAGED_FILES=$(git status --porcelain | awk '{$1=""; print $0 }' | grep -E "(${FILES})" | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

CHANGED_FILES=""


if [[ -n "$STAGED_FILES" && -n "$UNSTAGED_FILES" ]]; then
  echo "Found staged "$STAGED_FILES" and unstaged "$UNSTAGED_FILES" file(s)..."
  CHANGED_FILES="$STAGED_FILES|$UNSTAGED_FILES"
elif [[ -n "$STAGED_FILES" && -z "$UNSTAGED_FILES" ]]; then
  echo "Found staged file(s)..."
  CHANGED_FILES="$STAGED_FILES"
elif [[ -n "$UNSTAGED_FILES" && -z "$STAGED_FILES" ]]; then
  echo "Found unstaged file(s)..."
  CHANGED_FILES="$UNSTAGED_FILES"
fi

echo "$CHANGED_FILES"

CHANGED_FILES=$(echo "$CHANGED_FILES"  | awk '{gsub(/\|/,"\n"); print $0;}' | sort -u | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

echo "$CHANGED_FILES"

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
