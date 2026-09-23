#!/usr/bin/env bash

cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Projects - Mohammad Firas Sada</title>
  <meta name="description" content="Selected projects by Mohammad Firas Sada — sFlow collection on NRP, Rucio-SENSE data movement, AI accelerator metrics, P4 on FPGAs, and more.">
  <link rel="stylesheet" href="/static/style.css">
</head>
<body>
EOF

source components/header.sh

cat <<'EOF'
<main class="main-content">

<div class="section-title">
  <h2>Projects</h2>
</div>
EOF

cat <<'EOF'
<div class="entry-list">
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/nrp-header-collection">nrp-header-collection</a></div>
    <div class="entry-row__meta">A minimal sFlow collector for Kubernetes. Listens on UDP/6343 behind a ClusterIP service and decodes samples to JSON or PCAP, with a self-test notebook. The practical way to get network packet data on the National Research Platform.</div>
  </div>
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/rucio-sense-dmm">rucio-sense-dmm</a></div>
    <div class="entry-row__meta">The Data Movement Manager: the interface layer between Rucio/FTS and SENSE so HEP transfers can request SDN circuits. X.509 and SENSE OAuth credentials, Helm deployment on NRP, web UI with site refresh.</div>
  </div>
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/qaic-prometheus-exporter">qaic-prometheus-exporter</a></div>
    <div class="entry-row__meta">Prometheus exporter for Qualcomm Cloud AI 100 accelerators. Scrapes qaic-util every 15 seconds and exposes 20+ per-QID metrics: power, temperature, DRAM, NSP utilization, inference load. Injected via ConfigMap, no custom image.</div>
  </div>
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/llms-or-naive-bayes">llms-or-naive-bayes</a></div>
    <div class="entry-row__meta">Reproduction artifact for the PEARC '26 paper "LLMs or Naive Bayes? Old Gems or New Ways". Complement Naive Bayes vs zero/few-shot LLMs across four model families and a 37x scale range, with a Helm operator that picks the model by policy.</div>
  </div>
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/P4-on-Xilinx-FPGAs">P4-on-Xilinx-FPGAs</a></div>
    <div class="entry-row__meta">Docs and examples for running P4 programs on Xilinx FPGAs: Vivado for the hardware side, P4 tools for the language, and the glue in between. Where I learned that packet processing is a memory budget, not a clock speed.</div>
  </div>
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/esnet-smartnic-hw-sn1022">esnet-smartnic-hw-sn1022</a></div>
    <div class="entry-row__meta">Hardware bring-up for the ESnet SmartNIC on SN1022-based cards, with Malleable Networks and Apical Networks. DOE-funded, covered by Berkeley Lab IP oversight.</div>
  </div>
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/Baseball-WAR-in-R">Baseball-WAR-in-R</a></div>
    <div class="entry-row__meta">Wins Above Replacement in R. A forever project: park factors, positional adjustments, fielding runs, and the honest argument that no WAR number is better than its assumptions.</div>
  </div>
  <div class="entry-row">
    <div class="entry-row__title"><a href="https://github.com/groundsada/7NRP-AI-Presentation">7NRP-AI-Presentation</a></div>
    <div class="entry-row__meta">The 30-minute AI infrastructure talk I gave at the 7th National Research Platform Workshop (2026, UC San Diego / SDSC), built with Slidev.</div>
  </div>
</div>
EOF

source components/footer.sh

cat <<'EOF'
</body>
</html>
EOF
