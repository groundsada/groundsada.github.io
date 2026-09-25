#!/usr/bin/env bash

set -e

echo "Building static site..."

# Clean
rm -rf dist/
mkdir -p dist/

# Environment
export DEV=${DEV:-true}
export PORT="${PORT:-3002}"
export TCP_PROVIDER=tcpserver

if ! command -v tcpserver &> /dev/null; then
  export TCP_PROVIDER=nc
fi

# Use an existing render server if provided (avoids startup races)
if [[ -z "$SOURCE_URL" ]]; then
  ./start.sh > /dev/null 2>&1 &
  SERVER_PID=$!
  echo "Waiting for server..."
  for i in {1..15}; do
    if curl -s http://localhost:$PORT/ > /dev/null 2>&1; then
      echo "Server ready!"
      break
    fi
    sleep 1
  done
  BASE="http://localhost:$PORT"
else
  BASE="${SOURCE_URL%/}"
  echo "Using render server at $BASE"
fi

# Fetch pages
fetch_page() {
  local path=$1
  local output=$2
  echo "  Fetching $path"
  curl -s "$BASE$path" > "dist/$output" 2>/dev/null || {
    echo "  ERROR: Failed to fetch $path"
    return 1
  }
  [[ ! -s "dist/$output" ]] && echo "  ERROR: Empty file" && return 1
  
  # Clean up
  if [[ -f "dist/$output" ]]; then
    sed -i.bak '/<div style="display:none" hx-ext="sse"/,/<\/div>/d' "dist/$output" 2>/dev/null || true
    rm -f "dist/$output.bak"
  fi
}

fetch_page "/" "index.html"
fetch_page "/blog" "blog.html"
fetch_page "/about" "about.html"
fetch_page "/projects" "projects.html"
fetch_page "/safebox" "safebox.html"

# Blog posts (previously never fetched -> lived site had 404s)
mkdir -p dist/blog
for md in blog/*.md; do
  slug=$(basename "$md" .md)
  fetch_page "/blog/$slug" "blog/$slug.html" || exit 1
done

# Copy assets
cp -r static dist/
touch dist/.nojekyll

# Kill server (only if we started one)
if [[ -n "$SERVER_PID" ]]; then
  kill $SERVER_PID 2>/dev/null || true
  wait $SERVER_PID 2>/dev/null || true
fi
rm -rf pubsub sessions 2>/dev/null || true

echo "Build complete!"
ls -lh dist/






