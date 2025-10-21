#!/bin/bash

NO_STYLES=false

htmx_page << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Mohammad Firas Sada | groundsada</title>
    <meta name="description" content="Artificial Intelligence • Software Engineering • Tech" />

    <link rel="stylesheet" href="/static/css/style.css" />

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700;900&display=swap"
      rel="stylesheet"
    />
  </head>
  <body>
EOF

# Render all components
source components/header.sh
source components/hero.sh
source components/about.sh
source components/blog.sh
source components/projects.sh
source components/footer.sh

cat << 'EOF'
    <script src="/static/index.js"></script>
  </body>
</html>
EOF

