#!/usr/bin/env bash

# Get project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

LIMIT=${1:-3}  # Default show 3 posts

cat <<'EOF'
<div class="section-title">
  <h2>Recent Posts</h2>
</div>
<div class="entries-list">
EOF

# Find blog posts
if [[ -d "$PROJECT_ROOT/blog" ]]; then
  POSTS=$(find "$PROJECT_ROOT/blog" -name "*.md" -type f | sort -r | head -n $LIMIT)
  
  if [[ -z "$POSTS" ]]; then
    echo "<p>No posts yet.</p>"
  else
    while IFS= read -r post_file; do
      # Extract frontmatter
      TITLE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^title:/{sub(/^title:[[:space:]]*/, ""); print}' "$post_file")
      DATE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^date:/{sub(/^date:[[:space]]*, ""); print}' "$post_file")
      EXCERPT=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^excerpt:/{sub(/^excerpt:[[:space:]]*/, ""); print}' "$post_file")
      SLUG=$(basename "$post_file" .md)
      
      # Fallbacks
      [[ -z "$TITLE" ]] && TITLE=$(basename "$post_file" .md | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
      [[ -z "$DATE" ]] && DATE="Recently"
      [[ -z "$EXCERPT" ]] && EXCERPT="Read more..."
      
      cat <<POST
  <article class="entry">
    <h3 class="entry__title">
      <a href="/blog/$SLUG">$TITLE</a>
    </h3>
    <div class="entry__meta">$DATE</div>
    <div class="entry__excerpt">
      <p>$EXCERPT</p>
      <a href="/blog/$SLUG" class="entry__more-link">Read more →</a>
    </div>
  </article>
POST
    done <<< "$POSTS"
  fi
fi

cat <<'EOF'
</div>
EOF






