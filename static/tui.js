/* groundsada TUI — clean. No prefill, no demo. Just a terminal. */
(function () {
  const el = document.getElementById("tui");
  if (!el) return;
  const out = el.querySelector(".tui-body");
  const input = el.querySelector(".tui-input");
  const prompt = "firas@groundsada";

  const DATA = {
    whoami: [
      ["Mohammad Firas Sada", ""],
      ["research networking systems engineer", ""],
      ["i move science data & build networks you can program", ""],
    ],
    now: [
      ["making high-energy physics data move", ""],
      ["just published PEARC '26: LLMs or Naive Bayes?", ""],
      ["teaching the National Research Platform", ""],
      ["side projects: Jupyter-Agent, JupyterCluster, Jaily", ""],
    ],
    projects: [
      ["jupyter-agent/", "ssh-over-https + port-forward + one-click vscode"],
      ["jupyter-cluster/", "a hub that provisions many JupyterHubs"],
      ["llms-or-naive-bayes/", "PEARC '26 — NB beats 1T MoE on labeled data"],
      ["nrp-header-collection/", "sFlow packet data on the NRP"],
      ["qaic-prometheus-exporter/", "20+ metrics for Cloud AI 100"],
      ["jaily/", "natural language → BPF filters"],
    ],
    papers: [
      ["LLMs or Naive Bayes? Old Gems or New Ways", "PEARC '26 · arXiv:2609.13185"],
      ["Real-Time In-Network ML on P4 FPGA SmartNICs", "PEARC '25"],
      ["Serving LLMs in HPC Clusters: QC AI 100 vs NVIDIA", "PEARC '25"],
      ["The NRP: Stretched, Multi-Tenant, Scientific k8s", "PEARC '25"],
    ],
    talks: [
      ["Introduction to the National Research Platform", "EPOC · Jun 2025"],
      ["Inter-Testbed Networking: FPGA/SmartNICs (FABRIC & NRP)", "EPOC · Jul 2025"],
      ["SmartNIC tutorial series: Xilinx Alveo (YouTube)", "video"],
    ],
    help: [
      ["commands: whoami · now · projects · papers · talks · clear · sudo rm -rf /", ""],
      ["tab autocompletes · ↑ recalls history", ""],
    ],
    sudo: [["nice try. this terminal is on the friendly side.", "err"]],
  };

  const KEYS = ["help", "whoami", "now", "projects", "papers", "talks", "clear", "sudo"];
  const history = [];
  let hIdx = -1;

  function syncWidth() {
    // floor 5ch so the 4-char "help" placeholder is fully visible (2ch clipped it to "he")
    input.style.width = Math.max(5, input.value.length + 1) + "ch";
  }

  function print(s, cls) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    div.textContent = s;
    out.appendChild(div);
    out.scrollTop = out.scrollHeight;
  }

  function run(cmd) {
    print(prompt + " $ " + cmd, "tui-cmd");
    const c = cmd.trim();
    if (!c) return;
    if (c !== "clear") history.push(c);
    hIdx = history.length;
    if (c === "clear") {
      out.innerHTML = "";
      return;
    }
    if (DATA[c]) {
      DATA[c].forEach(([t, d]) => print(d ? t + "  " + d : t, d === "err" ? "tui-err" : d ? "tui-out" : "tui-ok"));
    } else if (c.startsWith("sudo")) {
      DATA.sudo.forEach(([t]) => print(t, "tui-err"));
    } else {
      print("command not found: " + c + " — try help", "tui-err");
    }
  }

  input.addEventListener("input", syncWidth);
  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      run(input.value);
      input.value = "";
      syncWidth();
    } else if (e.key === "Tab") {
      e.preventDefault();
      const v = input.value.toLowerCase();
      const m = KEYS.find((k) => k.startsWith(v));
      if (m) { input.value = m; syncWidth(); }
    } else if (e.key === "ArrowUp") {
      e.preventDefault();
      if (hIdx > 0) input.value = history[--hIdx];
      syncWidth();
    } else if (e.key === "ArrowDown") {
      e.preventDefault();
      if (hIdx < history.length - 1) input.value = history[++hIdx];
      else { hIdx = history.length; input.value = ""; }
      syncWidth();
    }
  });

  document.querySelectorAll(".tui-chip").forEach((chip) => {
    chip.addEventListener("click", () => run(chip.getAttribute("data-cmd")));
  });

  // ergonomics: clicking anywhere on the terminal focuses the input
  el.addEventListener("click", () => { try { input.focus(); } catch (e) {} });
  syncWidth();
  input.focus();
})();
