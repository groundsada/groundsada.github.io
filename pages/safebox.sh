#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Matrix Exit Certificate - groundsada</title>
  <meta name="description" content="Sealed proof of the one. You may have seen nothing.">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">
  <div class="entry" style="max-width: 640px; margin: 40px auto; text-align: center; padding: 46px 34px;">
    <div class="section-title"><h2>Certificate</h2></div>
    <h1 style="font-family: var(--display); font-size: 2.2rem; margin: 6px 0 4px; color: #4ade80; text-transform: uppercase; text-shadow: 0 0 22px rgba(74,222,128,.6);">Matrix Exit</h1>
    <p style="color: #b3a9d2;">browser-scoped &middot; non-transferable &middot; no refunds</p>
    <hr style="border: none; border-top: 1px solid #2c2140; margin: 26px 0;">
    <p style="color: #e8e2f2;">This certifies that</p>
    <p style="font-family: var(--display); font-size: 1.7rem; color: #ff2d95; text-transform: uppercase; margin: 10px 0;">firas, probably the rabbit</p>
    <p style="color: #e8e2f2;">woke with a single Enter, followed the rabbit, deciphered the transmission,<br>
    defused agent.core, and dissolved smith without killing a single copy.<br>
    (the terminal was never actually broken. that is the joke.)</p>
    <p style="color: #b3a9d2; margin-top: 22px;">&ldquo;congratulations, the certificate prints itself.&rdquo;</p>
    <div style="margin-top: 30px; display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
      <a class="btn" href="/">back to the real world</a>
      <a class="btn" href="/about">about the rabbit</a>
    </div>
  </div>
</main>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF
