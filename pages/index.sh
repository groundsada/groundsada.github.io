#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mohammad Firas Sada - Researcher at SDSC</title>
  <meta name="description" content="Researcher at San Diego Supercomputer Center specializing in HPC, AI/ML, networking, and FPGA acceleration">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">
EOF

source components/intro.sh
source components/recent-posts.sh 3
source components/projects.sh 3

cat <<'EOF'
</main>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF






