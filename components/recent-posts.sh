#!/usr/bin/env bash

# Get project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

LIMIT=${1:-3}  # Default show 3 posts

cat <<'EOF'
<div class="section-title">
  <h2>Recent Posts</h2>
</div>
<div class="entries-list">
EOF

# Find blog posts, sorted by frontmatter date (newest first)
if [[ -d "$PROJECT_ROOT/blog" ]]; then
  POSTS=$(for post_file in "$PROJECT_ROOT"/blog/*.md; do
    [[ -f "$post_file" ]] || continue
    DATE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^date:/{sub(/^date:[[:space:]]*/, ""); print}' "$post_file")
    [[ -z "$DATE" ]] && DATE="0000-00-00"
    printf '%s\t%s\n' "$DATE" "$post_file"
  done | sort -r | head -n "$LIMIT")

  if [[ -z "$POSTS" ]]; then
    echo "<p>No posts yet.</p>"
  else
    while IFS=$'\t' read -r POST_DATE post_file; do
      # Extract frontmatter
      TITLE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^title:/{sub(/^title:[[:space:]]*/, ""); print}' "$post_file" | sed 's/^"//; s/"$//')
      EXCERPT=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^excerpt:/{sub(/^excerpt:[[:space:]]*/, ""); print}' "$post_file" | sed 's/^"//; s/"$//')
      SLUG=$(basename "$post_file" .md)

      [[ -z "$TITLE" ]] && TITLE=$(basename "$post_file" .md | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
      [[ -z "$EXCERPT" ]] && EXCERPT="Read more..."

      cat <<POST
  <article class="entry">
    <h3 class="entry__title">
      <a href="/blog/$SLUG">$TITLE</a>
    </h3>
    <div class="entry__meta">$POST_DATE</div>
    <div class="entry__excerpt">
      <p>$EXCERPT</p>
      <a href="/blog/$SLUG" class="entry__more-link">Read more &rarr;</a>
    </div>
  </article>
POST
    done <<< "$POSTS"
  fi
fi

cat <<'EOF'
</div>
EOF
