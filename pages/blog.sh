#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Blog - Mohammad Firas Sada</title>
  <meta name="description" content="Technical blog on HPC, AI/ML, FPGAs, and distributed systems">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">
  <div class="page-intro">
    <h1 class="page-intro__title">Blog</h1>
    <p class="page-intro__lead">Technical writing on HPC, AI/ML, and systems</p>
  </div>
EOF

source components/recent-posts.sh 10

cat <<'EOF'
</main>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF






