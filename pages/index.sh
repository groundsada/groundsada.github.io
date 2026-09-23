#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mohammad Firas Sada - Research Networking Systems Engineer at ESnet</title>
  <meta name="description" content="Research networking systems engineer at ESnet/LBNL — scientific data movement, SENSE-SDN orchestration, programmable networks, and AI/ML infrastructure for high-energy physics.">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">
EOF

source components/intro.sh
source components/publications.sh
source components/recent-posts.sh 3
source components/projects.sh 5

cat <<'EOF'
</main>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF
