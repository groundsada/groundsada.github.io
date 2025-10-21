#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load profile data
PROFILE=$(cat "$PROJECT_ROOT/data/profile.json")
NAME=$(echo "$PROFILE" | grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
PHOTO=$(echo "$PROFILE" | grep -o '"photo"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4 | sed 's|^\./|/static/|')

cat <<EOF
<header class="header">
  <div class="header__content">
    <div class="header__logo-container">
      <div class="header__logo-img-cont">
        <img
          src="$PHOTO"
          alt="$NAME"
          class="header__logo-img"
        />
      </div>
      <span class="header__logo-sub">$NAME</span>
    </div>
    <div class="header__main">
      <ul class="header__links">
        <li class="header__link-wrapper">
          <a href="./index.html" class="header__link"> Home </a>
        </li>
        <li class="header__link-wrapper">
          <a href="#about" class="header__link">About </a>
        </li>
        <li class="header__link-wrapper">
          <a href="#blog" class="header__link"> Blog </a>
        </li>
        <li class="header__link-wrapper">
          <a href="#projects" class="header__link">
            Projects
          </a>
        </li>
      </ul>
      <div class="header__main-ham-menu-cont">
        <img
          src="/static/assets/svg/ham-menu.svg"
          alt="hamburger menu"
          class="header__main-ham-menu"
        />
        <img
          src="/static/assets/svg/ham-menu-close.svg"
          alt="hamburger menu close"
          class="header__main-ham-menu-close d-none"
        />
      </div>
    </div>
  </div>
  <div class="header__sm-menu">
    <div class="header__sm-menu-content">
      <ul class="header__sm-menu-links">
        <li class="header__sm-menu-link">
          <a href="./index.html"> Home </a>
        </li>
        <li class="header__sm-menu-link">
          <a href="#about"> About </a>
        </li>
        <li class="header__sm-menu-link">
          <a href="#blog"> Blog </a>
        </li>
        <li class="header__sm-menu-link">
          <a href="#projects"> Projects </a>
        </li>
      </ul>
    </div>
  </div>
</header>
EOF

