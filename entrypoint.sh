#!/usr/bin/env bash

set -ex

INPUT_SEPARATOR="${INPUT_SEPARATOR//\%/%25}"
INPUT_SEPARATOR="${INPUT_SEPARATOR//\./%2E}"

NEWLINE_SEPARATOR="\n"
URLENCODED_NEWLINE_SEPARATOR='%0A'
INPUT_SEPARATOR="${INPUT_SEPARATOR//$NEWLINE_SEPARATOR/$URLENCODED_NEWLINE_SEPARATOR}"

CARRIAGE_RETURN="\r"
URLENCODED_CARRIAGE_RETURN='%0D'
INPUT_SEPARATOR="${INPUT_SEPARATOR//$CARRIAGE_RETURN/$URLENCODED_CARRIAGE_RETURN}"

echo "::group::verify-changed-files"

if [[ -n "$INPUT_FILES_PATTERN_FILE" ]]; then
  TRACKED_FILES=$(git diff --diff-filter=ACMUXTRD --name-only | grep -x -E -f "$INPUT_FILES_PATTERN_FILE" | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find untracked changes
  UNTRACKED_FILES=$(git ls-files --others --exclude-standard | grep -x -E -f "$INPUT_FILES_PATTERN_FILE" | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')
else
  TRACKED_FILES=$(git diff --diff-filter=ACMUXTRD --name-only | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find untracked changes
  UNTRACKED_FILES=$(git ls-files --others --exclude-standard | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')
fi

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

  CHANGED_FILES=$(echo "$CHANGED_FILES" | awk '{gsub(/\|/,"\n"); print $0;}' | awk -v d="$INPUT_SEPARATOR" '{s=(NR==1?s:s d)$0}END{print s}')
  
  if [[ -z "$GITHUB_OUTPUT" ]]; then
    echo "::set-output name=files_changed::true"
    echo "::set-output name=changed_files::$CHANGED_FILES"
  else
    echo "files_changed=true" >> "$GITHUB_OUTPUT"
    echo "changed_files=$CHANGED_FILES" >> "$GITHUB_OUTPUT"
  fi
  
else
  echo "No changes found."
  
  if [[ -z "$GITHUB_OUTPUT" ]]; then
    echo "::set-output name=files_changed::false"
  else
    echo "files_changed=false" >> "$GITHUB_OUTPUT"
  fi
fi

echo "::endgroup::"
