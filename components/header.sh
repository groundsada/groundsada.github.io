#!/usr/bin/env bash

# Get project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load profile
PROFILE=$(cat "$PROJECT_ROOT/data/profile.json")
if command -v jq &> /dev/null; then
  NAME=$(echo "$PROFILE" | jq -r '.name')
else
  NAME="Mohammad Firas Sada"
fi

cat <<'EOF'
<header class="site-header">
  <div class="site-header__inner">
    <h1 class="site-title">
      <a href="/">groundsada</a>
    </h1>
    <nav class="site-nav">
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/blog">Blog</a></li>
        <li><a href="https://github.com/groundsada" target="_blank">GitHub</a></li>
      </ul>
    </nav>
  </div>
</header>
EOF






