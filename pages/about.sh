#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>About - Mohammad Firas Sada</title>
  <meta name="description" content="About Mohammad Firas Sada, research networking systems engineer at ESnet, formerly SDSC. Moving science data, building programmable networks, teaching the NRP.">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">
EOF

source components/intro.sh

cat <<'EOF'
  <section class="about-section">
    <h2>The short version</h2>
    <p>I'm a research networking systems engineer at <strong>ESnet</strong> (Energy Sciences Network) at Lawrence Berkeley National Laboratory, where I work on moving high-energy physics data across the country: software-defined networks for science, SENSE orchestration, and the interop between the transfer tools researchers actually use.</p>
    <p>Before ESnet I was at the <strong>San Diego Supercomputer Center</strong> (UC San Diego), where I worked on all sorts of things: the National Research Platform (NRP) Kubernetes substrate and its FABRIC integration, the SENSE Kubernetes operator, segment routing on FPGAs, CUDA tooling, Prometheus exporters for novel chips, and P4 with machine learning on SmartNICs. I'm also a three-PEARC-poster-and-paper person. Most recently PEARC '26 (<em>LLMs or Naive Bayes?</em>), and an instructor for SDSC's NRP courses.</p>
  </section>

  <section class="about-section">
    <h2>What I care about</h2>
    <ul>
      <li><strong>Infrastructure people can actually use.</strong> A platform that needs a handbook to join isn't finished; it's in beta.</li>
      <li><strong>Programmable data planes.</strong> I've spent real hours compiling P4 to FPGAs and I'd do it again.</li>
      <li><strong>Honest measurements.</strong> If you're going to compare models (or networks, or clusters), publish the method.</li>
      <li><strong>Teaching.</strong> You don't understand a system until you've explained it to someone who doesn't care about your system.</li>
    </ul>
  </section>

  <section class="about-section">
    <h2>Off the clock</h2>
    <p>Baseball analytics in R (a permanently in-progress WAR calculator), machine-learning image experiments, competitive-programming warmups, and a long-standing belief that every big idea deserves a small weekend prototype.</p>
  </section>
EOF

source components/publications.sh

cat <<'EOF'
  <section class="about-section">
    <h2>Find me</h2>
    <p>GitHub: <a href="https://github.com/groundsada">github.com/groundsada</a> · LinkedIn: <a href="https://www.linkedin.com/in/msada">linkedin.com/in/msada</a> · Papers: <a href="https://arxiv.org/abs/2609.13185">arXiv</a></p>
  </section>
</main>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF
