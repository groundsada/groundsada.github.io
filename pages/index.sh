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
<div class="vc-cover" id="hero">
  <div class="vc-cover__sky" data-parallax="0.05"></div>
  <div class="vc-cover__sun"></div>
  <div class="vc-cover__palms" data-parallax="0.10"></div>
  <div class="vc-cover__grid" data-parallax="0.03"></div>
  <div class="vc-cover__inner">
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
  </div>
</div>

<main class="main-content">
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
