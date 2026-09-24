/* groundsada TUI v4 — challenge box, now with working Wordle colors + toys.
   No help. No clues. Fake FS, hidden Wordle, rickroll trap, and a toy drawer. */
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
  const WORDS = ["NODES", "PORTS", "FIBER", "PACKS", "BYTES", "SCALE", "SENSE", "FLOWS", "NEONS", "ROUTE", "QUEUE", "ETHER"];

  const FORTUNES = [
    "you will move petabytes. you will also debug sFlow at 2am.",
    "today's forecast: packet storms with a chance of flow control.",
    "a network that works quietly is the best kind of art.",
    "your packet will cross the country before your coffee does.",
    "measure twice, transfer once.",
  ];
  const FAKE_HISTORY = [
    "sudo apt install friends",
    "curl -s https://www.life.com | grep 'meaning'",
    "ping science.gov (timeout: weekend)",
    "git commit -m 'it was working before i touched it'",
    "rm -rf problems",
    "ssh lab@moon --vpn-ok",
    "cat /dev/null > todo-list",
  ];
  const FAKE_COMMITS = [
    "add: vibes module",
    "remove: bugs (fiction)",
    "fix: glanced at it",
    "docs: wrote nothing",
    "perf: 10x faster (in my head)",
    "refactor: renamed everything, broke nothing*",
  ];

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

  /* ---------- toys ---------- */
  const toys = {
    history() {
      print("fabricated. none of this happened.", "tui-out");
      FAKE_HISTORY.forEach((h) => print("  " + h, "tui-ok"));
    },
    fortune() {
      print("        \\  |  /", "tui-ok");
      print("         \\ | /", "tui-ok");
      print("    (\\  (o_o)  /)", "tui-out");
      print("     \\   (oo)   /", "tui-out");
      print("      \\_______/", "tui-out");
      print(FORTUNES[Math.floor(Math.random() * FORTUNES.length)], "tui-ok");
    },
    party() {
      el.classList.add("tui--party");
      print("ok. no one can focus now.", "tui-out");
      setTimeout(() => el.classList.remove("tui--party"), 4200);
    },
    matrix() {
      print("wake up, sheeple.", "tui-out");
      const glyphs = "アイウエオカキクケコサシスセソ01<>[]{}#$%&";
      let n = 0;
      const iv = setInterval(() => {
        if (n++ > 26) { clearInterval(iv); print("make some noise.", "tui-ok"); return; }
        let line = "";
        for (let i = 0; i < 46; i++) line += glyphs[Math.floor(Math.random() * glyphs.length)];
        print(line, "tui-ok");
      }, 70);
    },
    ping() {
      print("PING science.gov (10.0.0.42): 56 data bytes", "tui-out");
      print("64 bytes: time=2.3ms  (feeling optimistic)", "tui-ok");
      print("64 bytes: time=342.9ms (crossed the country)", "tui-ok");
      print("64 bytes: time=8.1ms   (found a shorter path)", "tui-ok");
      print("--- 3 packets transmitted, 3 received, 0% loss ---", "tui-out");
    },
    weather() {
      print("portland: 61F — gray, like a tcp window", "tui-ok");
      print("berkeley: 68F — blue skies, zero congestion", "tui-ok");
      print("the network: 99.99% — rain expected on friday", "tui-out");
    },
    gitlog() {
      print("current branch: main (definitely stable)", "tui-out");
      FAKE_COMMITS.forEach((c) => print("  " + c, "tui-ok"));
      print("  * but everything still works", "tui-out");
    },
    coffee() {
      print("brewing...", "tui-out");
      print("estimated completion: never. i am a terminal.", "tui-ok");
    },
    exit() {
      print("there is no exit. this terminal is a lifestyle.", "tui-out");
    },
    sudo() {
      print("permission denied. you are not my real sudo.", "tui-err");
    },
    chmod() {
      print("chmod: changing mode of 'life' to 777 — brave.", "tui-ok");
    },
  };

  /* ---------- wordle ---------- */
  function startWordle() {
    mode = "wordle";
    word = WORDS[Math.floor(Math.random() * WORDS.length)];
    tries = 0;
    print("you found it.", "tui-out");
    print("five letters. six tries. lowercase.", "tui-out");
  }
  window.__setWordleWord = function (w) { word = w.toUpperCase(); };
  function renderGuess(guess) {
    const row = document.createElement("div");
    row.className = "tui-line";
    const g = guess.toUpperCase(), w = word;
    const counts = {};
    for (const ch of w) counts[ch] = (counts[ch] || 0) + 1;
    const marked = new Array(5).fill(null);
    for (let i = 0; i < 5; i++) if (g[i] === w[i]) { marked[i] = "wg"; counts[g[i]]--; }
    for (let i = 0; i < 5; i++) {
      if (marked[i]) continue;
      if (counts[g[i]] > 0) { marked[i] = "wa"; counts[g[i]]--; } else marked[i] = "wx";
    }
    for (let i = 0; i < 5; i++) {
      row.appendChild(span(g[i], "tui-w " + marked[i]));
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
    if (g.toUpperCase() === word) {
      print("you got it in " + tries + (tries === 1 ? " try." : " tries.") + " no clues were given.", "tui-ok");
      mode = "shell";
    } else if (tries >= MAX_TRIES) {
      print("out of tries. it was “" + word.toLowerCase() + "”.", "tui-err");
      mode = "shell";
    }
  }

  /* ---------- shell ---------- */
  function run(cmdRaw) {
    print(prompt + ":" + cwd + " $ " + cmdRaw, "tui-cmd");
    const cmd = cmdRaw.trim();
    if (!cmd) return;
    const parts = cmd.split(/\s+/);
    const c = parts[0].toLowerCase();

    if (/\brm\b/.test(c)) { rickroll(); return; }

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
      case "history": toys.history(); return;
      case "fortune": toys.fortune(); return;
      case "party": toys.party(); return;
      case "matrix": toys.matrix(); return;
      case "ping": toys.ping(); return;
      case "weather": toys.weather(); return;
      case "git": if (parts[1] === "log") toys.gitlog(); else print("git: try `git log`", "tui-err"); return;
      case "coffee": toys.coffee(); return;
      case "exit": case "quit": toys.exit(); return;
      case "sudo": toys.sudo(); return;
      case "chmod": toys.chmod(); return;
      default: print("command not found: " + c, "tui-err");
    }
  }

  input.addEventListener("input", syncWidth);
  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const v = input.value;
      if (/\brm\b/i.test(v)) {
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
