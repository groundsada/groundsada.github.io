#!/usr/bin/env bash

# Publications + talks (sourced from data/publications.json)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cat <<'EOF'
<div class="section-title">
  <h2>Papers</h2>
</div>
<div class="entry-list">
EOF

if [[ -f "$PROJECT_ROOT/data/publications.json" ]] && command -v jq &> /dev/null; then
  jq -r '.publications[] | @json' "$PROJECT_ROOT/data/publications.json" | while read -r pub; do
    TITLE=$(echo "$pub" | jq -r '.title')
    AUTHORS=$(echo "$pub" | jq -r '.authors')
    VENUE=$(echo "$pub" | jq -r '.venue')
    URL=$(echo "$pub" | jq -r '.url // ""')
    cat <<ITEM
  <div class="entry-row">
    <div class="entry-row__title"><a href="$URL" target="_blank" rel="noopener">$TITLE</a></div>
    <div class="entry-row__meta">$VENUE · $AUTHORS</div>
  </div>
ITEM
  done
fi

cat <<'EOF'
</div>

<div class="section-title">
  <h2>Talks</h2>
</div>
<div class="entry-list">
EOF

jq -r '.talks[] | @json' "$PROJECT_ROOT/data/publications.json" 2>/dev/null | while read -r talk; do
  TITLE=$(echo "$talk" | jq -r '.title')
  VENUE=$(echo "$talk" | jq -r '.venue')
  URL=$(echo "$talk" | jq -r '.url // ""')
  cat <<ITEM
  <div class="entry-row">
    <div class="entry-row__title"><a href="$URL" target="_blank" rel="noopener">$TITLE</a> <span class="entry-row__kind">(video)</span></div>
    <div class="entry-row__meta">$VENUE</div>
  </div>
ITEM
done

cat <<'EOF'
</div>
EOF
