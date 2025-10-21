#!/bin/bash

# Get the blog post slug from path variable
SLUG=${PATH_VARS[slug]}

# Get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

BLOG_FILE="$PROJECT_ROOT/blog/${SLUG}.md"

if [[ ! -f "$BLOG_FILE" ]]; then
  # Blog post not found
  return $(status_code 404)
fi

# Extract frontmatter
TITLE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^title:/{sub(/^title:[[:space:]]*/, ""); print}' "$BLOG_FILE")
DATE=$(awk '/^---$/{f=1;next}/^---$/{f=0}f&&/^date:/{sub(/^date:[[:space:]]*/, ""); print}' "$BLOG_FILE")

# Get content after frontmatter
CONTENT=$(awk '/^---$/{ if(++count==2) next_line=1; next } next_line' "$BLOG_FILE")

# Simple markdown to HTML conversion
convert_markdown() {
  echo "$1" | sed -E \
    -e 's/^# (.+)$/<h1>\1<\/h1>/' \
    -e 's/^## (.+)$/<h2>\1<\/h2>/' \
    -e 's/^### (.+)$/<h3>\1<\/h3>/' \
    -e 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g' \
    -e 's/\*([^*]+)\*/<em>\1<\/em>/g' \
    -e 's/\[([^\]]+)\]\(([^)]+)\)/<a href="\2" target="_blank">\1<\/a>/g' \
    -e 's/^$/\n<br>/'
}

BODY=$(convert_markdown "$CONTENT")

NO_STYLES=false

htmx_page << EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>$TITLE | Mohammad Firas Sada</title>
    <meta name="description" content="$TITLE" />
    <link rel="stylesheet" href="/static/css/style.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700;900&display=swap"
      rel="stylesheet"
    />
    <style>
      .blog-article {
        max-width: 80rem;
        margin: 4rem auto;
        padding: 0 2rem;
      }
      .blog-article h1 {
        font-size: 3.5rem;
        margin-bottom: 1rem;
      }
      .blog-article h2 {
        font-size: 2.5rem;
        margin: 2rem 0 1rem;
      }
      .blog-article h3 {
        font-size: 2rem;
        margin: 1.5rem 0 1rem;
      }
      .blog-article p {
        font-size: 1.7rem;
        line-height: 1.8;
        margin-bottom: 1.5rem;
      }
      .blog-meta {
        color: #666;
        font-size: 1.4rem;
        margin-bottom: 2rem;
      }
      .back-link {
        display: inline-block;
        margin-bottom: 2rem;
        color: #0062b9;
        text-decoration: none;
        font-size: 1.6rem;
      }
      .back-link:hover {
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
EOF

source components/header.sh

cat << EOF
    <div class="blog-article">
      <a href="/" class="back-link">← Back to Home</a>
      <div class="blog-meta">$DATE</div>
      <article>
        $BODY
      </article>
    </div>
EOF

source components/footer.sh

cat << 'EOF'
    <script src="/static/index.js"></script>
  </body>
</html>
EOF

