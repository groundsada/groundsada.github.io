#!/usr/bin/env bash

set -e

# Clean previous builds
rm -rf dist/
mkdir -p dist/

# Build Tailwind CSS for production (optional - we use the pre-compiled CSS)
echo "Note: Using pre-compiled CSS from static/css/style.css"
# Tailwind compilation is optional since we already have compiled CSS
if command -v npx &> /dev/null; then
  npx --yes tailwindcss@latest -i ./static/tailwind-input.css -o ./static/tailwind.css --minify 2>/dev/null || true
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
echo "Waiting for server to be ready..."
for i in {1..10}; do
  if curl -s http://localhost:$PORT/ > /dev/null 2>&1; then
    echo "Server is ready!"
    break
  fi
  sleep 1
done

# Function to fetch and save a page
fetch_page() {
  local path=$1
  local output=$2
  
  # Fetch the page and save to dist
  curl -s "http://localhost:$PORT$path" > "dist/$output" 2>/dev/null || {
    echo "  ERROR: Failed to fetch $path (is server running?)"
    return 1
  }
  
  # Check if file was created and has content
  if [[ ! -s "dist/$output" ]]; then
    echo "  ERROR: Fetched file is empty"
    return 1
  fi
  
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
