#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load profile data
PROFILE=$(cat "$PROJECT_ROOT/data/profile.json")
GREETING=$(echo "$PROFILE" | grep -o '"greeting"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
TITLE=$(echo "$PROFILE" | grep -o '"title"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
LINKEDIN=$(echo "$PROFILE" | grep -o '"linkedin"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
GITHUB=$(echo "$PROFILE" | grep -o '"github"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
INSTAGRAM=$(echo "$PROFILE" | grep -o '"instagram"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

cat <<EOF
<section class="home-hero">
  <div class="home-hero__content">
    <h1 class="heading-primary">$GREETING</h1>
    <div class="home-hero__info">
      <p class="text-primary">
        $TITLE
      </p>
    </div>
    <div class="home-hero__cta">
      <a href="#projects" class="btn btn--bg">Projects</a>
    </div>
  </div>
  <div class="home-hero__socials">
    <div class="home-hero__social">
      <a href="$LINKEDIN" class="home-hero__social-icon-link">
        <img
          src="/static/assets/png/linkedin-ico.png"
          alt="LinkedIn"
          class="home-hero__social-icon"
        />
      </a>
    </div>
    <div class="home-hero__social">
      <a href="$GITHUB" class="home-hero__social-icon-link">
        <img
          src="/static/assets/png/github-ico.png"
          alt="GitHub"
          class="home-hero__social-icon"
        />
      </a>
    </div>
    <div class="home-hero__social">
      <a
        href="$INSTAGRAM"
        class="home-hero__social-icon-link home-hero__social-icon-link--bd-none"
      >
        <img
          src="/static/assets/png/insta-ico.png"
          alt="Instagram"
          class="home-hero__social-icon"
        />
      </a>
    </div>
  </div>
  <div class="home-hero__mouse-scroll-cont">
    <div class="mouse"></div>
  </div>
</section>
EOF

