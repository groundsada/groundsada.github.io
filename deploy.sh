#!/bin/bash

set -e

# Check if dist exists
if [[ ! -d "dist" ]]; then
  exit 1
fi

# Check if git repo is initialized
if [[ ! -d ".git" ]]; then
  exit 1
fi

# Save current branch
CURRENT_BRANCH=$(git branch --show-current)

# Check if there are uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "Build: $(date '+%Y-%m-%d %H:%M:%S')" || true
fi

# Create gh-pages branch if it doesn't exist
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
  git checkout --orphan gh-pages
  git rm -rf .
  git checkout $CURRENT_BRANCH
fi

# Deploy using git subtree
git subtree push --prefix dist origin gh-pages