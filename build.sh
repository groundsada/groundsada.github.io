#!/usr/bin/env bash

set -e

echo "Building static site..."

# Clean
rm -rf dist/
mkdir -p dist/

# Environment
export DEV=false
export PORT=3002
export TCP_PROVIDER=tcpserver

[[ ! command -v tcpserver &> /dev/null ]] && export TCP_PROVIDER=nc

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
  curl -s "http://localhost:$PORT$path" > "dist/$output" 2>/dev/null || {
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

# Copy assets
cp -r static dist/
touch dist/.nojekyll

# Kill server
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true
rm -rf pubsub sessions 2>/dev/null || true

echo "Build complete!"
ls -lh dist/






