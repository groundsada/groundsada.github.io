#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# GitHub username
GITHUB_USER="groundsada"

# Check if we should fetch from GitHub API or use cache
CACHE_FILE="$PROJECT_ROOT/data/github-projects-cache.json"
CACHE_AGE_HOURS=24

should_fetch_from_api() {
  if [[ ! -f "$CACHE_FILE" ]]; then
    return 0 # true
  fi
  
  # Check if cache is older than CACHE_AGE_HOURS
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    FILE_TIME=$(stat -f %m "$CACHE_FILE")
  else
    # Linux
    FILE_TIME=$(stat -c %Y "$CACHE_FILE")
  fi
  
  CURRENT_TIME=$(date +%s)
  AGE_SECONDS=$((CURRENT_TIME - FILE_TIME))
  AGE_HOURS=$((AGE_SECONDS / 3600))
  
  if [[ $AGE_HOURS -gt $CACHE_AGE_HOURS ]]; then
    return 0 # true
  fi
  
  return 1 # false
}

# Fetch projects from GitHub API
fetch_github_projects() {
  echo "Fetching projects from GitHub API..." >&2
  
  # Fetch repos sorted by updated (most recent)
  REPOS=$(curl -s "https://api.github.com/users/$GITHUB_USER/repos?sort=updated&per_page=100")
  
  # Save to cache
  echo "$REPOS" > "$CACHE_FILE"
  
  echo "$REPOS"
}

# Get projects (from API or cache)
if should_fetch_from_api; then
  PROJECTS=$(fetch_github_projects)
else
  PROJECTS=$(cat "$CACHE_FILE")
fi

# Parse projects and generate HTML
cat <<'EOF'
<section id="projects" class="projects sec-pad">
  <div class="main-container">
    <h2 class="heading heading-sec heading-sec__mb-bg">
      <span class="heading-sec__main">Projects</span>
      <span class="heading-sec__sub">
        Open source and research
      </span>
    </h2>

    <div class="projects__content">
EOF

# Parse JSON and generate project cards (show only 3 most recent)
if command -v jq &> /dev/null; then
  # Use jq for JSON parsing - get 3 most recently updated non-fork repos
  echo "$PROJECTS" | jq -r '.[] | select(.fork == false) | @json' | head -3 | while read -r project; do
    NAME=$(echo "$project" | jq -r '.name')
    DESC=$(echo "$project" | jq -r '.description // "No description available"')
    URL=$(echo "$project" | jq -r '.html_url')
    STARS=$(echo "$project" | jq -r '.stargazers_count')
    LANG=$(echo "$project" | jq -r '.language // "Unknown"')
    
    cat <<PROJECT_HTML
      <div class="projects__row" style="margin-bottom: 1rem;">
        <div class="projects__row-content" style="max-width: 100%; padding: 2rem;">
          <h3 class="projects__row-content-title" style="font-size: 2.2rem; margin-bottom: 1rem;">$NAME</h3>
          <p class="projects__row-content-desc" style="font-size: 1.5rem; margin-bottom: 1rem;">
            $DESC
          </p>
          <div style="margin: 10px 0; font-size: 1.4rem; color: #666;">
            <span style="display: inline-block; margin-right: 15px;">$STARS stars</span>
            <span style="display: inline-block; margin-right: 15px;">$LANG</span>
          </div>
          <a
            href="$URL"
            class="btn btn--med btn--theme dynamicBgClr"
            target="_blank"
            style="font-size: 1.4rem; padding: 1rem 2rem;"
            >View on GitHub</a
          >
        </div>
      </div>
PROJECT_HTML
  done
else
  # Fallback: manual project list if jq is not available
  cat <<'FALLBACK_PROJECTS'
      <div class="projects__row">
        <div class="projects__row-content" style="max-width: 100%;">
          <h3 class="projects__row-content-title">Visit GitHub</h3>
          <p class="projects__row-content-desc">
            Check out my projects on GitHub!
          </p>
          <a
            href="https://github.com/groundsada"
            class="btn btn--med btn--theme dynamicBgClr"
            target="_blank"
            >View GitHub Profile</a
          >
        </div>
      </div>
FALLBACK_PROJECTS
fi

cat <<EOF
    </div>
    
    <!-- View More Button -->
    <div style="text-align: center; margin-top: 3rem;">
      <a
        href="https://github.com/$GITHUB_USER?tab=repositories"
        class="btn btn--bg"
        target="_blank"
        style="font-size: 1.6rem; padding: 1.5rem 3rem;"
        >View All Projects on GitHub</a
      >
    </div>
  </div>
</section>
EOF
