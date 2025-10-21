#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load profile data
PROFILE=$(cat "$PROJECT_ROOT/data/profile.json")

if command -v jq &> /dev/null; then
  NAME=$(echo "$PROFILE" | jq -r '.name')
  SHORT_TITLE=$(echo "$PROFILE" | jq -r '.shortTitle')
  LINKEDIN=$(echo "$PROFILE" | jq -r '.social.linkedin')
  GITHUB=$(echo "$PROFILE" | jq -r '.social.github')
  INSTAGRAM=$(echo "$PROFILE" | jq -r '.social.instagram')
else
  NAME="Mohammad Firas Sada"
  SHORT_TITLE="Upcoming Master's Grad in Artificial Intelligence | Software Engineer | Tech Enthusiast"
  LINKEDIN="https://www.linkedin.com/in/msada"
  GITHUB="https://github.com/groundsada"
  INSTAGRAM="https://www.instagram.com/firas_sada/"
fi

cat <<EOF
<footer class="main-footer">
  <div class="main-container">
    <div class="main-footer__upper">
      <div class="main-footer__row main-footer__row-1">
        <h2 class="heading heading-sm main-footer__heading-sm">
          <span>Social</span>
        </h2>
        <div class="main-footer__social-cont">
          <a target="_blank" rel="noreferrer" href="$LINKEDIN">
            <img
              class="main-footer__icon"
              src="/static/assets/png/linkedin-ico.png"
              alt="icon"
            />
          </a>
          <a target="_blank" rel="noreferrer" href="$GITHUB">
            <img
              class="main-footer__icon"
              src="/static/assets/png/github-ico.png"
              alt="icon"
            />
          </a>
          <a target="_blank" rel="noreferrer" href="$INSTAGRAM">
            <img
              class="main-footer__icon main-footer__icon--mr-none"
              src="/static/assets/png/insta-ico.png"
              alt="icon"
            />
          </a>
        </div>
      </div>
      <div class="main-footer__row main-footer__row-2">
        <h4 class="heading heading-sm text-lt">$NAME</h4>
        <p class="main-footer__short-desc">
          $SHORT_TITLE
        </p>
      </div>
    </div>

    <div class="main-footer__lower">
      &copy; Copyright 2023-2025. Made by <a rel="noreferrer" href="./index.html#about"
      >$NAME</a>. Template forked from
      <a rel="noreferrer" target="_blank" href="https://rammaheshwari.com"
        >Ram Maheshwari</a
      >.
      <br><br>
      <strong>Powered by <a rel="noreferrer" target="_blank" href="https://github.com/cgsdev0/bash-stack">bash-stack</a></strong> 
      - A full-stack web framework written entirely in Bash. This portfolio showcases the power of bash-stack through 
      component-based architecture, dynamic GitHub API integration for automatic project updates, a markdown-based blog 
      engine with YAML frontmatter parsing, and data-driven content management through JSON files. The development environment 
      features hot module reloading, while the build process pre-renders everything to static HTML for blazing-fast GitHub 
      Pages hosting. All routing, templating, API calls, and content generation accomplished using pure Bash scripts. 
      <a rel="noreferrer" target="_blank" href="https://github.com/groundsada/groundsada.github.io">View complete source code</a> 
      to see how Bash can power modern web applications.
    </div>
  </div>
</footer>
EOF

