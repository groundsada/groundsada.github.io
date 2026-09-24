/* groundsada TUI v3 — the challenge box.
   No help. No clues. A fabricated filesystem, a hidden Wordle, and a trap. */
(function () {
  const el = document.getElementById("tui");
  if (!el) return;
  const out = el.querySelector(".tui-body");
  const input = el.querySelector(".tui-input");
  const prompt = "firas@groundsada";

  let mode = "shell";
  let cwd = "~";
  let word = "", tries = 0, rick = false;
  const MAX_TRIES = 6;

  const DIRS = {
    "~": "docs/  hints.txt  notes.txt  projects/  README.md",
    "docs": "p4-notes.md  wordle.md",
    "projects": "jupyter-agent/  jupyter-cluster/",
  };
  const FILES = {
    "README.md": "You found my corner of the internet.\n(psst: hidden files in this terminal are not all a joke)",
    "notes.txt": "things that have to work: the network, the transfer, the measurement.\nthings that don't: everything else.",
    "hints.txt": "five letters.\nsix tries.\nlowercase.",
    ".secret": "nice. you looked. type 'wordle' and prove it.",
    "docs/wordle.md": "LEAKED doc. if you are reading this, the game is spelled out on purpose.\nthere is nothing here. go type something else.",
    "docs/p4-notes.md": "- packet processing is a memory budget, not a clock speed\n- 100G is a baseline, not a flex\n- always measure before optimizing\n- sFlow: sample everything, apologize to no one",
  };
  const WORDS = ["PACKET", "FIBER", "SCALE", "BYTES", "NODES", "PORTS", "SENSE", "FLOWS", "NEONS", "GRID"];

  function print(s, cls) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    if (typeof s === "string") div.textContent = s; else div.appendChild(s);
    out.appendChild(div);
    out.scrollTop = out.scrollHeight;
  }
  function span(txt, cls) {
    const s = document.createElement("span");
    s.className = cls; s.textContent = txt; return s;
  }
  function syncWidth() { input.style.width = Math.max(2, input.value.length + 1) + "ch"; }

  function rickroll() {
    out.innerHTML = "";
    print("nice try.", "tui-err");
    const wrap = document.createElement("div");
    wrap.className = "tui-rick";
    const ifr = document.createElement("iframe");
    ifr.src = "https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ?autoplay=1";
    ifr.allow = "autoplay; encrypted-media; fullscreen";
    ifr.allowFullscreen = true;
    ifr.title = "rick";
    wrap.appendChild(ifr);
    const label = document.createElement("div");
    label.className = "tui-rick__label";
    label.textContent = "never gonna give you up — click the terminal to back out";
    wrap.appendChild(label);
    out.appendChild(wrap);
    rick = true;
    out.scrollTop = out.scrollHeight;
  }

  function startWordle() {
    mode = "wordle";
    word = WORDS[Math.floor(Math.random() * WORDS.length)];
    tries = 0;
    print("you found it.", "tui-out");
    print("five letters. six tries. lowercase.", "tui-out");
  }
  function renderGuess(guess) {
    const row = document.createElement("div");
    row.className = "tui-line";
    const counts = {};
    for (const ch of word) counts[ch] = (counts[ch] || 0) + 1;
    const marked = new Array(5).fill(null);
    for (let i = 0; i < 5; i++) if (guess[i] === word[i]) { marked[i] = "wg"; counts[guess[i]]--; }
    for (let i = 0; i < 5; i++) {
      if (marked[i]) continue;
      if (counts[guess[i]] > 0) { marked[i] = "wa"; counts[guess[i]]--; } else marked[i] = "wx";
    }
    for (let i = 0; i < 5; i++) {
      row.appendChild(span(guess[i].toUpperCase(), "tui-w " + marked[i]));
      if (i < 4) row.appendChild(span(" ", "tui-w"));
    }
    out.appendChild(row);
    out.scrollTop = out.scrollHeight;
  }
  function wordleGuess(raw) {
    const g = raw.toLowerCase().trim();
    if (g === "exit" || g === "quit") { mode = "shell"; print("back to the shell.", "tui-out"); return; }
    if (!/^[a-z]{5}$/.test(g)) { print("five letters.", "tui-err"); return; }
    renderGuess(g);
    tries++;
    if (g === word.toLowerCase()) {
      print("you got it in " + tries + (tries === 1 ? " try." : " tries.") + " no clues were given.", "tui-ok");
      mode = "shell";
    } else if (tries >= MAX_TRIES) {
      print("out of tries. it was “" + word.toLowerCase() + "”.", "tui-err");
      mode = "shell";
    }
  }

  function run(cmdRaw) {
    print(prompt + ":" + cwd + " $ " + cmdRaw, "tui-cmd");
    const cmd = cmdRaw.trim();
    if (!cmd) return;
    const parts = cmd.split(/\s+/);
    const c = parts[0].toLowerCase();

    if (/^rm/.test(c)) { rickroll(); return; }

    switch (c) {
      case "clear": out.innerHTML = ""; return;
      case "whoami":
        print("Mohammad Firas Sada", "tui-ok");
        print("research networking systems engineer — remote", "tui-out");
        print("i move science data & build networks you can program", "tui-out");
        return;
      case "now":
        print("making high-energy physics data move", "tui-out");
        print("just published PEARC '26: LLMs or Naive Bayes?", "tui-out");
        print("teaching the National Research Platform", "tui-out");
        return;
      case "ls": {
        const all = parts[1] === "-a" && cwd === "~";
        if (cwd === "~" && all) print(".  ..  .secret  " + DIRS["~"], "tui-out");
        else if (DIRS[cwd]) print(DIRS[cwd], "tui-out");
        else print("", "tui-out");
        return;
      }
      case "cd": {
        const t = parts[1];
        if (!t || t === "~") cwd = "~";
        else if (t === "docs") cwd = "docs";
        else if (t === "projects") cwd = "projects";
        else if (t === "..") cwd = "~";
        else print("cd: no such directory: " + t, "tui-err");
        return;
      }
      case "pwd": print(cwd, "tui-out"); return;
      case "cat": {
        const path = parts[1];
        const key = cwd === "~" ? path : cwd + "/" + path;
        if (FILES[key]) print(FILES[key], "tui-out");
        else print("cat: " + path + ": no such file", "tui-err");
        return;
      }
      case "wordle": startWordle(); return;
      default: print("command not found: " + c, "tui-err");
    }
  }

  input.addEventListener("input", syncWidth);
  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const v = input.value;
      // the trap is global: even mid-game, rm -rf gets you got
      if (/^rm/i.test(v.trim())) {
        print(prompt + ":" + cwd + " $ " + v, "tui-cmd");
        input.value = ""; syncWidth();
        rickroll();
        return;
      }
      input.value = ""; syncWidth();
      if (mode === "wordle") wordleGuess(v); else run(v);
    } else if (e.key === "Tab") {
      e.preventDefault(); // no clues.
    }
  });

  el.addEventListener("click", () => {
    if (rick) { rick = false; out.innerHTML = ""; mode = "shell"; }
    try { input.focus(); } catch (e) {}
  });

  syncWidth();
  input.focus();
})();
