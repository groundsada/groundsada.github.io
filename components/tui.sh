#!/usr/bin/env bash

cat <<'EOF'
<div class="tui" id="tui">
  <div class="tui-bar">
    <span class="tui-dot" style="background:#f9765b"></span>
    <span class="tui-dot" style="background:#f4c04f"></span>
    <span class="tui-dot" style="background:#6fd18b"></span>
    <span class="tui-bar-title">firas@groundsada: ~</span>
  </div>
  <div class="tui-body" id="tui-body"></div>
  <div class="tui-prompt-row">
    <span class="tui-prompt">firas@groundsada $</span>
    <input class="tui-input" id="tui-input" spellcheck="false" autocomplete="off" autocapitalize="none" aria-label="terminal input">
    <span class="tui-cursor"></span>
  </div>
</div>
<script src="/static/tui.js"></script>
EOF
