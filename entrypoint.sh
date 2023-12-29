#!/usr/bin/env bash

set -euo pipefail

INPUT_SEPARATOR="${INPUT_SEPARATOR//\%/%25}"
INPUT_SEPARATOR="${INPUT_SEPARATOR//\./%2E}"
INPUT_SEPARATOR="${INPUT_SEPARATOR//\\n/%0A}"
INPUT_SEPARATOR="${INPUT_SEPARATOR//\\r/%0D}"

echo "::group::verify-changed-files"

echo "Separator: $INPUT_SEPARATOR"

GIT_STATUS_EXTRA_ARGS="-u --porcelain"

if [[ "$INPUT_MATCH_GITIGNORE_FILES" == "true" ]]; then
  GIT_STATUS_EXTRA_ARGS+=" --ignored"
fi

if [[ -n "$INPUT_FILES_PATTERN_FILE" ]]; then
  TRACKED_FILES=$(git diff --diff-filter=ACMUXTR --name-only | { grep -x -E -f "$INPUT_FILES_PATTERN_FILE" || true; } | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find untracked changes
  # shellcheck disable=SC2086
  UNTRACKED_OR_IGNORED_FILES=$(git status $GIT_STATUS_EXTRA_ARGS | awk '{print $NF}' | { grep -x -E -f "$INPUT_FILES_PATTERN_FILE" || true; } | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find unstaged deleted files
  UNSTAGED_DELETED_FILES=$(git ls-files --deleted | { grep -x -E -f "$INPUT_FILES_PATTERN_FILE" || true; } | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')
else
  TRACKED_FILES=$(git diff --diff-filter=ACMUXTR --name-only | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find untracked changes
  # shellcheck disable=SC2086
  UNTRACKED_OR_IGNORED_FILES=$(git status $GIT_STATUS_EXTRA_ARGS | awk '{print $NF}' | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find unstaged deleted files
  UNSTAGED_DELETED_FILES=$(git ls-files --deleted | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')
fi

CHANGED_FILES=""

# Function to concatenate non-empty file names with a separator
concatenate() {
  local separator=$1
  shift
  local result=""
  for filename in "$@"; do
    if [[ "$INPUT_SAFE_OUTPUT" == "true" ]]; then
      filename=${filename//$/\\$} # Replace $ with \$
      filename=${filename//\(/\\\(} # Replace ( with \(
      filename=${filename//\)/\\\)} # Replace ) with \)
      filename=${filename//\`/\\\`} # Replace ` with \`
      filename=${filename//|/\\|} # Replace | with \|
      filename=${filename//&/\\&} # Replace & with \&
      filename=${filename//;/\\;} # Replace ; with \;
    fi
    if [[ -n $filename ]]; then
      if [[ -n $result ]]; then
        result+="$separator$filename"
      else
        result="$filename"
      fi
    fi
  done
  echo "$result"
}

# Concatenate non-empty strings with a '|' separator
CHANGED_FILES=$(concatenate "|" "$TRACKED_FILES" "$UNTRACKED_OR_IGNORED_FILES" "$UNSTAGED_DELETED_FILES")

CHANGED_FILES=$(echo "$CHANGED_FILES"  | awk '{gsub(/\|/,"\n"); print $0;}' | sort -u | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

if [[ -n "$CHANGED_FILES" ]]; then
  echo "Found uncommitted changes"

  CHANGED_FILES=$(echo "$CHANGED_FILES" | awk '{gsub(/\|/,"\n"); print $0;}' | awk -v d="$INPUT_SEPARATOR" '{s=(NR==1?s:s d)$0}END{print s}')

  echo "files_changed=true" >> "$GITHUB_OUTPUT"
  echo "changed_files=$CHANGED_FILES" >> "$GITHUB_OUTPUT"

  if [[ "$INPUT_FAIL_IF_CHANGED" == "true" ]]; then
    if [[ -n "$INPUT_FAIL_MSG" ]]; then
      echo "::error::$INPUT_FAIL_MSG"
    fi
    exit 1
  fi
else
  echo "No changes found."
  echo "files_changed=false" >> "$GITHUB_OUTPUT"
fi

echo "::endgroup::"
