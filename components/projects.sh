#!/usr/bin/env bash

# Get project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

GITHUB_USER="groundsada"
CACHE_FILE="$PROJECT_ROOT/data/github-cache.json"
LIMIT=${1:-3}

# Simple cache check
should_fetch() {
  [[ ! -f "$CACHE_FILE" ]] && return 0
  find "$CACHE_FILE" -mmin +1440 2>/dev/null | grep -q . && return 0  # 24 hours
  return 1
}

# Fetch from GitHub
if should_fetch; then
  curl -s "https://api.github.com/users/$GITHUB_USER/repos?sort=updated&per_page=50" > "$CACHE_FILE" 2>/dev/null || true
fi

cat <<'EOF'
<div class="section-title">
  <h2>Recent Projects</h2>
</div>
EOF

if [[ -f "$CACHE_FILE" ]] && command -v jq &> /dev/null; then
  cat "$CACHE_FILE" | jq -r '.[] | select(.fork == false) | @json' | head -n $LIMIT | while read -r project; do
    NAME=$(echo "$project" | jq -r '.name')
    DESC=$(echo "$project" | jq -r '.description // "No description"')
    URL=$(echo "$project" | jq -r '.html_url')
    STARS=$(echo "$project" | jq -r '.stargazers_count')
    LANG=$(echo "$project" | jq -r '.language // "Code"')
    
    cat <<PROJECT
<div class="project-card">
  <h3 class="project-card__title">
    <a href="$URL" target="_blank">$NAME</a>
  </h3>
  <div class="project-card__meta">$LANG • $STARS stars</div>
  <div class="project-card__desc">
    <p>$DESC</p>
  </div>
  <a href="$URL" class="btn btn-secondary" target="_blank">View on GitHub</a>
</div>
PROJECT
  done
else
  cat <<'FALLBACK'
<div class="project-card">
  <h3 class="project-card__title">
    <a href="https://github.com/groundsada" target="_blank">View Projects</a>
  </h3>
  <div class="project-card__desc">
    <p>Check out my open source projects and research work on GitHub.</p>
  </div>
  <a href="https://github.com/groundsada?tab=repositories" class="btn" target="_blank">View All Repositories</a>
</div>
FALLBACK
fi

cat <<EOF
<div class="text-center mt-4">
  <a href="https://github.com/$GITHUB_USER?tab=repositories" class="btn" target="_blank">View All Projects</a>
</div>
EOF






