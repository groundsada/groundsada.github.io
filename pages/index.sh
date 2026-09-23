#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mohammad Firas Sada - Research Networking Systems Engineer at ESnet</title>
  <meta name="description" content="Research networking systems engineer at ESnet/LBNL — software-defined networks and transfer tooling for high-energy physics data movement. Remote. Petabytes. Orchestrated.">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">
  <section class="hero-stage" id="hero">
    <div class="hero-layer hero-layer--sun" data-parallax="0.18"></div>
    <div class="hero-layer hero-layer--grid" data-parallax="0.05"></div>
    <div class="hero-layer hero-layer--blob" data-parallax="0.22"></div>
    <div class="hero-layer hero-layer--dotsphere" data-parallax="0.12"></div>
    <div class="hero-grid">
      <div>
EOF

source components/intro.sh

cat <<'EOF'
      </div>
EOF

source components/tui.sh

cat <<'EOF'
    </div>
  </section>
EOF

source components/recent-posts.sh 3
source components/projects.sh 5

cat <<'EOF'
</main>
EOF

source components/footer.sh

cat <<'EOF'
<script src="/static/parallax.js"></script>
</body>
</html>
EOF
