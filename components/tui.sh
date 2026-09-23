#!/usr/bin/env bash

cat <<'EOF'
<div class="tui" id="tui">
  <div class="tui-bar">
    <span class="tui-dot" style="background:#f9765b"></span>
    <span class="tui-dot" style="background:#f4c04f"></span>
    <span class="tui-dot" style="background:#6fd18b"></span>
    <span class="tui-bar-title">firas@esnet: ~</span>
    <span class="tui-bar-note">charmbracelet</span>
  </div>
  <div class="tui-chips">
    <button class="tui-chip" data-cmd="whoami">whoami</button>
    <button class="tui-chip" data-cmd="now">now</button>
    <button class="tui-chip" data-cmd="projects">projects</button>
    <button class="tui-chip" data-cmd="papers">papers</button>
    <button class="tui-chip" data-cmd="talks">talks</button>
    <button class="tui-chip" data-cmd="help">help</button>
    <button class="tui-chip" data-cmd="sudo rm -rf /">sudo…</button>
  </div>
  <div class="tui-body" id="tui-body">
    <div class="tui-line tui-out">&gt; booting… type <b>help</b> or click a chip.</div>
  </div>
  <div class="tui-prompt-row">
    <span class="tui-prompt">firas@esnet $</span>
    <input class="tui-input" id="tui-input" spellcheck="false" autocomplete="off" aria-label="terminal input">
    <span class="tui-cursor"></span>
  </div>
</div>
<script src="/static/tui.js"></script>
EOF
