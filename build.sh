#!/usr/bin/env bash

set -e

echo "Building static site..."

# Clean
rm -rf dist/
mkdir -p dist/

# Environment
export DEV=false
export PORT=${PORT:-3002}
export TCP_PROVIDER=tcpserver

if ! command -v tcpserver &> /dev/null; then
  export TCP_PROVIDER=nc
fi

# Start server
./start.sh > /dev/null 2>&1 &
SERVER_PID=$!

# Wait for ready
echo "Waiting for server..."
for i in {1..15}; do
  if curl -s http://localhost:$PORT/ > /dev/null 2>&1; then
    echo "Server ready!"
    break
  fi
  sleep 1
done

# Fetch pages
fetch_page() {
  local path=$1
  local output=$2
  echo "  Fetching $path"
  # NOTE: core.sh closes the socket with a TCP RST after a complete response,
  # so curl exits 56 even on success. Verify by content, not exit code, and
  # retry truncated responses (race can cut a page mid-stream).
  local attempt
  for attempt in 1 2 3; do
    curl -s "http://localhost:$PORT$path" > "dist/$output" 2>/dev/null || true
    if [[ -s "dist/$output" ]] && grep -q '</html>' "dist/$output"; then
      break
    fi
    sleep 1
  done
  if [[ ! -s "dist/$output" ]] || ! grep -q '</html>' "dist/$output"; then
    echo "  ERROR: Empty or truncated page for $path"
    return 1
  fi
  
  # Clean up
  if [[ -f "dist/$output" ]]; then
    sed -i.bak '/<div style="display:none" hx-ext="sse"/,/<\/div>/d' "dist/$output" 2>/dev/null || true
    rm -f "dist/$output.bak"
  fi
}

fetch_page "/" "index.html"
fetch_page "/blog" "blog.html"
fetch_page "/about" "about.html"

# Pre-render individual blog posts (fixes /blog/<slug> 404s)
mkdir -p dist/blog
for post in blog/*.md; do
  [ -f "$post" ] || continue
  slug=$(basename "$post" .md)
  fetch_page "/blog/$slug" "blog/$slug.html"
done

# Copy assets
cp -r static dist/
touch dist/.nojekyll

# Kill server
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true
rm -rf pubsub sessions 2>/dev/null || true

echo "Build complete!"
ls -lh dist/






