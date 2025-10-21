#!/bin/bash

set -e

# Clean previous builds
rm -rf dist/
mkdir -p dist/

# Build Tailwind CSS for production
if command -v npx &> /dev/null; then
  npx tailwindcss -i ./static/tailwind-input.css -o ./static/tailwind.css --minify
else
  echo "npx not found. Tailwind CSS will not be built."
fi

# Set environment to production mode
export DEV=false
export PORT=3001
export TCP_PROVIDER=tcpserver

# Check if tcpserver is available, fallback to nc
if ! command -v tcpserver &> /dev/null; then
  export TCP_PROVIDER=nc
  echo "tcpserver not found, using netcat"
fi

# Start the bash-stack server in the background
./start.sh > /dev/null 2>&1 &
SERVER_PID=$!

# Wait for server to be ready
sleep 3

# Function to fetch and save a page
fetch_page() {
  local path=$1
  local output=$2
  
  # Fetch the page and save to dist
  curl -s "http://localhost:$PORT$path" > "dist/$output" 2>/dev/null || {
    return 1
  }
  
  # Post-process HTML: remove HTMX, HMR, and bash-stack specific features
  # This makes it a pure static site
  if [[ -f "dist/$output" ]]; then
    # Remove HMR div
    sed -i.bak '/<div style="display:none" hx-ext="sse"/,/<\/div>/d' "dist/$output" 2>/dev/null || true
    # Remove HTMX script tags (optional - keep for interactivity)
    # sed -i.bak '/<script.*htmx.*<\/script>/d' "dist/$output" 2>/dev/null || true
    rm -f "dist/$output.bak"
  fi
}

# Fetch all pages
fetch_page "/" "index.html"

# Copy static assets
cp -r static dist/ 2>/dev/null || echo "⚠️  No static directory found"
cp -r sass dist/ 2>/dev/null || true

# Copy any other HTML files (project pages, etc.)
for file in *.html; do
  if [[ -f "$file" ]] && [[ "$file" != "index.html" ]]; then
    cp "$file" dist/
  fi
done

# Create CNAME file if custom domain is configured
if [[ ! -z "$CUSTOM_DOMAIN" ]]; then
  echo "$CUSTOM_DOMAIN" > dist/CNAME
fi

# Create .nojekyll to disable Jekyll processing on GitHub Pages
touch dist/.nojekyll

# Kill the server
kill $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true

# Clean up
rm -rf pubsub sessions 2>/dev/null || true

ls -lh dist/
