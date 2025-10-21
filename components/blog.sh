#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Function to extract frontmatter from markdown
extract_frontmatter() {
  local file=$1
  local key=$2
  
  # Extract YAML frontmatter between --- delimiters
  awk -v key="$key" '
    BEGIN { in_frontmatter=0 }
    /^---$/ { 
      in_frontmatter++
      next
    }
    in_frontmatter == 1 && $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "")
      gsub(/"/, "")
      print
      exit
    }
  ' "$file"
}

# Function to convert simple markdown to HTML
simple_markdown_to_html() {
  sed -E \
    -e 's/^# (.+)$/<h1>\1<\/h1>/' \
    -e 's/^## (.+)$/<h2>\1<\/h2>/' \
    -e 's/^### (.+)$/<h3>\1<\/h3>/' \
    -e 's/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g' \
    -e 's/\*([^*]+)\*/<em>\1<\/em>/g' \
    -e 's/\[([^\]]+)\]\(([^)]+)\)/<a href="\2">\1<\/a>/g' \
    -e 's/^$/<br>/'
}

cat <<'EOF'
<section id="blog" class="blog sec-pad">
  <div class="main-container">
    <h2 class="heading heading-sec heading-sec__mb-bg">
      <span class="heading-sec__main">Blog</span>
      <span class="heading-sec__sub">
        Technical writing on HPC and systems
      </span>
    </h2>

    <div class="blog__content">
EOF

# Check if blog directory exists and has markdown files
if [[ -d "$PROJECT_ROOT/blog" ]]; then
  # Find all markdown files, sort by modification time (newest first)
  BLOG_POSTS=$(find "$PROJECT_ROOT/blog" -name "*.md" -type f | sort -r | head -5)
  
  if [[ -z "$BLOG_POSTS" ]]; then
    # No blog posts yet
    cat <<'NO_POSTS'
      <div class="blog__post">
        <div class="blog__post-content">
          <h3 class="blog__post-title">Coming Soon</h3>
          <p class="blog__post-excerpt">
            Posts on HPC, FPGAs, and distributed systems coming soon.
          </p>
        </div>
      </div>
NO_POSTS
  else
    # Display blog posts
    while IFS= read -r post_file; do
      TITLE=$(extract_frontmatter "$post_file" "title")
      DATE=$(extract_frontmatter "$post_file" "date")
      EXCERPT=$(extract_frontmatter "$post_file" "excerpt")
      SLUG=$(basename "$post_file" .md)
      
      # Fallback if no frontmatter
      [[ -z "$TITLE" ]] && TITLE=$(basename "$post_file" .md | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
      [[ -z "$DATE" ]] && DATE=$(stat -f "%Sm" -t "%Y-%m-%d" "$post_file" 2>/dev/null || stat -c %y "$post_file" 2>/dev/null | cut -d' ' -f1)
      [[ -z "$EXCERPT" ]] && EXCERPT=$(grep -v '^---$' "$post_file" | grep -v '^[a-z]*:' | head -3 | tr '\n' ' ')
      
      cat <<BLOG_POST
      <div class="blog__post">
        <div class="blog__post-content">
          <div class="blog__post-meta">
            <span class="blog__post-date">$DATE</span>
          </div>
          <h3 class="blog__post-title">$TITLE</h3>
          <p class="blog__post-excerpt">
            $EXCERPT
          </p>
          <a href="/blog/$SLUG" class="btn btn--med btn--theme dynamicBgClr">Read More</a>
        </div>
      </div>
BLOG_POST
    done <<< "$BLOG_POSTS"
  fi
else
  # Blog directory doesn't exist
  cat <<'NO_DIR'
      <div class="blog__post">
        <div class="blog__post-content">
          <h3 class="blog__post-title">Coming Soon</h3>
          <p class="blog__post-excerpt">
            Posts on HPC, FPGAs, and distributed systems coming soon.
          </p>
        </div>
      </div>
NO_DIR
fi

cat <<'EOF'
    </div>
  </div>
</section>

<style>
.blog__content {
  display: flex;
  flex-direction: column;
  gap: 3rem;
}

.blog__post {
  background: #fff;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,.08);
  transition: transform .3s;
}

.blog__post:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 8px rgba(0,0,0,.15);
}

.blog__post-meta {
  color: #666;
  font-size: 1.4rem;
  margin-bottom: 1rem;
}

.blog__post-title {
  font-size: 2.8rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  color: #333;
}

.blog__post-excerpt {
  font-size: 1.6rem;
  line-height: 1.8;
  color: #666;
  margin-bottom: 2rem;
}
</style>
EOF

