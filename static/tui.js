/* groundsada TUI — a small Bubble Tea-inspired terminal widget (vanilla JS) */
(function () {
  const el = document.getElementById("tui");
  if (!el) return;
  const out = el.querySelector(".tui-body");
  const input = el.querySelector(".tui-input");
  const prompt = "firas@esnet";

  const DATA = {
    whoami: [
      "Mohammad Firas Sada",
      "research networking systems engineer @ ESnet (LBNL) — remote",
      "moves physics data; builds networks that can be programmed",
    ],
    now: [
      "> making HEP data move at ESnet",
      "> just published PEARC '26: LLMs or Naive Bayes?",
      "> teaching the National Research Platform",
      "> side projects: Jupyter-Agent, JupyterCluster, Jaily",
    ],
    projects: [
      "jupyter-agent/       ssh-over-https + port-forward + one-click vscode",
      "jupyter-cluster/     a hub that provisions many JupyterHubs",
      "llms-or-naive-bayes/ PEARC '26 — NB beats 1T MoE on labeled data",
      "nrp-header-collection/ sFlow packet data on the NRP",
      "qaic-prometheus-exporter/ 20+ metrics for Cloud AI 100",
      "jaily/               natural language → BPF filters",
    ],
    papers: [
      "LLMs or Naive Bayes? Old Gems or New Ways — PEARC '26 (arXiv:2609.13185)",
      "Real-Time In-Network ML on P4-Programmable FPGA SmartNICs — PEARC '25",
      "Serving LLMs in HPC Clusters: QC AI 100 Ultra vs NVIDIA GPUs — PEARC '25",
      "The NRP: Stretched, Multi-Tenant, Scientific Kubernetes Cluster — PEARC '25",
    ],
    talks: [
      "Introduction to the National Research Platform — EPOC, Jun 2025",
      "Inter-Testbed Networking: FPGA/SmartNICs across FABRIC & NRP — EPOC, Jul 2025",
      "SmartNIC tutorial series: Xilinx Alveo as SmartNICs (YouTube)",
    ],
    help: [
      "available commands:",
      "  whoami      now         projects    papers",
      "  talks       clear       help",
      "hint: try “whoami”, then “projects”. tab-complete works.",
    ],
  };

  const KEYS = ["help", "whoami", "now", "projects", "papers", "talks", "clear"];

  function print(s, cls) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    div.textContent = s;
    out.appendChild(div);
  }

  function run(cmd) {
    print(prompt + " $ " + cmd, "tui-cmd");
    const c = cmd.trim();
    if (!c) return;
    if (c === "clear") {
      out.innerHTML = "";
      return;
    }
    if (DATA[c]) {
      DATA[c].forEach((l) => print(l, "tui-out"));
    } else {
      print("command not found: " + c + " — try “help”", "tui-err");
    }
  }

  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      run(input.value);
      input.value = "";
    } else if (e.key === "Tab") {
      e.preventDefault();
      const v = input.value.toLowerCase();
      const m = KEYS.find((k) => k.startsWith(v));
      if (m) input.value = m;
    }
  });

  // auto-demo on load (makes it feel alive)
  const demo = ["whoami", "projects"];
  let t = 700;
  demo.forEach((c) => {
    setTimeout(() => {
      const el2 = input;
      el2.value = "";
      print(prompt + " $ " + c, "tui-cmd");
      let i = 0;
      const lines = DATA[c];
      const iv = setInterval(() => {
        print(lines[i], "tui-out");
        i++;
        if (i >= lines.length) clearInterval(iv);
      }, 120);
    }, t);
    t += 900;
  });

  window.tuiRun = run;
})();
