#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load skills data
SKILLS=$(cat "$PROJECT_ROOT/data/skills.json")

# Function to render skills
render_skills() {
  local category=$1
  if command -v jq &> /dev/null; then
    echo "$SKILLS" | jq -r ".$category[]" | while read -r skill; do
      echo "<div class=\"skills__skill\">$skill</div>"
    done
  else
    # Fallback without jq - parse JSON manually
    echo "$SKILLS" | grep -A 100 "\"$category\"" | grep '"' | head -n 20 | sed 's/.*"\(.*\)".*/\1/' | while read -r skill; do
      [[ ! -z "$skill" ]] && echo "<div class=\"skills__skill\">$skill</div>"
    done
  fi
}

# Render all skill categories
render_skills "languages"
render_skills "frameworks"
render_skills "cloud"
render_skills "spoken"

