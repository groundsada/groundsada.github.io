#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Projects - Mohammad Firas Sada</title>
  <meta name="description" content="Selected projects by Mohammad Firas Sada — packet data collection on the NRP, P4 on FPGAs, AI accelerator metrics, reproducible ML benchmarks, and more.">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">
EOF

source components/projects.sh

cat <<'EOF'
</main>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF
