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
  TRACKED_FILES=$(git diff --diff-filter=ACMUXTRD --name-only | { grep -x -E -f "$INPUT_FILES_PATTERN_FILE" || true; } | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find untracked changes
  # shellcheck disable=SC2086
  UNTRACKED_OR_IGNORED_FILES=$(git status $GIT_STATUS_EXTRA_ARGS | awk '{print $NF}' | { grep -x -E -f "$INPUT_FILES_PATTERN_FILE" || true; } | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')
else
  TRACKED_FILES=$(git diff --diff-filter=ACMUXTRD --name-only | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')

  # Find untracked changes
  # shellcheck disable=SC2086
  UNTRACKED_OR_IGNORED_FILES=$(git status $GIT_STATUS_EXTRA_ARGS | awk '{print $NF}' | awk -v d="|" '{s=(NR==1?s:s d)$0}END{print s}')
fi

CHANGED_FILES=""

if [[ -n "$TRACKED_FILES" && -n "$UNTRACKED_OR_IGNORED_FILES" ]]; then
  CHANGED_FILES="$TRACKED_FILES|$UNTRACKED_OR_IGNORED_FILES"
elif [[ -n "$TRACKED_FILES" && -z "$UNTRACKED_OR_IGNORED_FILES" ]]; then
  CHANGED_FILES="$TRACKED_FILES"
elif [[ -n "$UNTRACKED_OR_IGNORED_FILES" && -z "$TRACKED_FILES" ]]; then
  CHANGED_FILES="$UNTRACKED_OR_IGNORED_FILES"
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

  if [[ "$INPUT_FAIL_IF_CHANGED" == "true" ]]; then
    if [[ -n "$INPUT_FAIL_MSG" ]]; then
      echo "$INPUT_FAIL_MSG"
    fi
    exit 1
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
