#!/usr/bin/env bash

# Curated projects. No star counts, no API fetches.
# Usage: source with LIMIT (default 0 = all, grouped by category).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

LIMIT=${1:-0}

render_row() {
  local title="$1" desc="$2" url="$3"
  cat <<ROW
  <div class="entry-row">
    <div class="entry-row__title"><a href="$url" target="_blank" rel="noopener">$title</a></div>
    <div class="entry-row__desc">$desc</div>
  </div>
ROW
}

if [[ ! -f "$PROJECT_ROOT/data/projects.json" ]]; then
  echo "<p>Projects data unavailable.</p>"
  exit 0
fi

if [[ "$LIMIT" -gt 0 ]]; then
  # Homepage: featured only, with a link to the full page
  cat <<'EOF'
<div class="section-title">
  <h2>Recent projects</h2>
</div>
<div class="entry-list">
EOF
  jq -r '.projects[] | select(.featured == true) | @json' "$PROJECT_ROOT/data/projects.json" | head -n "$LIMIT" | while read -r p; do
    TITLE=$(echo "$p" | jq -r '.title'); DESC=$(echo "$p" | jq -r '.description'); URL=$(echo "$p" | jq -r '.url')
    render_row "$TITLE" "$DESC" "$URL"
  done
  cat <<'EOF'
</div>
<p style="font-size: 0.95rem;"><a href="/projects">All projects &rarr;</a></p>
EOF
else
  # Full page: grouped by category
  jq -r '.projects[].category' "$PROJECT_ROOT/data/projects.json" | sort -u | while read -r cat; do
    echo "<div class=\"section-title\"><h2>$cat</h2></div>"
    # 4-card categories get a 2x2 grid (--quad) so no card orphans in the 3-col rows
    CNT=$(jq --arg c "$cat" '[.projects[] | select(.category == $c)] | length' "$PROJECT_ROOT/data/projects.json")
    if [[ "$CNT" -eq 4 ]]; then
      echo '<div class="entry-list entry-list--quad">'
    else
      echo '<div class="entry-list">'
    fi
    jq -r --arg c "$cat" '.projects[] | select(.category == $c) | @json' "$PROJECT_ROOT/data/projects.json" | while read -r p; do
      TITLE=$(echo "$p" | jq -r '.title'); DESC=$(echo "$p" | jq -r '.description'); URL=$(echo "$p" | jq -r '.url')
      render_row "$TITLE" "$DESC" "$URL"
    done
    echo '</div>'
  done
fi
