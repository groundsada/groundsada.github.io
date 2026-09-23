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
  <div class="tui-body" id="tui-body">
    <div class="tui-line tui-out">> hello. type <b>help</b>, <b>projects</b>, or <b>papers</b>.</div>
  </div>
  <div class="tui-prompt-row">
    <span class="tui-prompt">firas@esnet $</span>
    <input class="tui-input" id="tui-input" spellcheck="false" autocomplete="off" aria-label="terminal input">
    <span class="tui-cursor"></span>
  </div>
</div>
<script src="/static/tui.js"></script>
EOF
