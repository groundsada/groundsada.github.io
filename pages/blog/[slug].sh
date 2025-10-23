#!/usr/bin/env bash

SLUG=${PATH_VARS[slug]}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BLOG_FILE="$PROJECT_ROOT/blog/${SLUG}.md"

if [[ ! -f "$BLOG_FILE" ]]; then
  return $(status_code 404)
fi

# Extract frontmatter
TITLE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^title:/{sub(/^title:[[:space:]]*/, ""); print}' "$BLOG_FILE")
DATE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^date:/{sub(/^date:[[:space:]]*/, ""); print}' "$BLOG_FILE")

# Get content after frontmatter
CONTENT=$(awk '/^---$/{ if(++count==2) next_line=1; next } next_line' "$BLOG_FILE")

# Convert markdown to HTML
convert_md() {
  echo "$1" | sed -E \
    -e 's/^# (.+)$/<h1>\1<\/h1>/' \
    -e 's/^## (.+)$/<h2>\1<\/h2>/' \
    -e 's/^### (.+)$/<h3>\1<\/h3>/' \
    -e 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g' \
    -e 's/\*([^*]+)\*/<em>\1<\/em>/g' \
    -e 's/\[([^\]]+)\]\(([^)]+)\)/<a href="\2">\1<\/a>/g' \
    -e 's/^- (.+)$/<li>\1<\/li>/' \
    -e 's/^$/\n<p>/'
}

BODY=$(convert_md "$CONTENT")

[[ -z "$TITLE" ]] && TITLE="Blog Post"
[[ -z "$DATE" ]] && DATE="Recently"

cat <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$TITLE - Mohammad Firas Sada</title>
  <meta name="description" content="$TITLE">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<EOF
<main class="main-content">
  <article class="entry">
    <p><a href="/blog">← Back to Blog</a></p>
    <h1 class="entry__title" style="font-size: 2.5rem; margin-bottom: 0.5rem;">$TITLE</h1>
    <div class="entry__meta" style="margin-bottom: 2rem;">$DATE</div>
    <div class="entry__content" style="max-width: 48rem;">
      $BODY
    </div>
  </article>
</main>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF






