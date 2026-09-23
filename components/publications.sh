#!/usr/bin/env bash

# Publications section (static, sourced from data/publications.json)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cat <<'EOF'
<div class="section-title">
  <h2>Publications</h2>
</div>
<div class="entries-list">
EOF

if [[ -f "$PROJECT_ROOT/data/publications.json" ]] && command -v jq &> /dev/null; then
  jq -r '.publications[] | @json' "$PROJECT_ROOT/data/publications.json" | while read -r pub; do
    TITLE=$(echo "$pub" | jq -r '.title')
    VENUE=$(echo "$pub" | jq -r '.venue')
    AUTHORS=$(echo "$pub" | jq -r '.authors')
    URL=$(echo "$pub" | jq -r '.url // ""')

    cat <<PUB
  <article class="entry">
    <h3 class="entry__title">
      <a href="$URL" target="_blank">$TITLE</a>
    </h3>
    <div class="entry__meta">$VENUE</div>
    <div class="entry__excerpt">
      <p>$AUTHORS</p>
    </div>
  </article>
PUB
  done
else
  echo "<p>Publications data unavailable.</p>"
fi

cat <<'EOF'
</div>
EOF
