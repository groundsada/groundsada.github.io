/* groundsada TUI v7 — Matrix intro + elaborate admin debugging journey.
   Real-ish fake FS: cd/ls/cat/grep/tail/cp/chown/chmod/systemctl. Two bugs. One flag. */
(function () {
  const el = document.getElementById("tui");
  if (!el) return;
  const out = el.querySelector(".tui-body");
  const input = el.querySelector(".tui-input");
  const PROMPT = "firas@groundsada";

  let woke = false, rick = false, mstep = 0, mode = "shell";
  let cwd = "/";
  let configFixed = false, tokenFixed = false, restarted = false;
  let journeyStarted = false;

  /* ---------------- fake filesystem ---------------- */
  const F = {
    etc: { appd: {
      "appd.conf": { t: "f", c: "[appd]\nrun_as = root\nmax_restarts = 3\nlog_level = info" },
      "appd.conf.dist": { t: "f", c: "[appd]\nrun_as = appd\nmax_restarts = 3\nlog_level = debug" },
      "appd.conf.bak": { t: "f", c: "[appd]\nrun_as = root\nmax_restarts = 3\nlog_level = info" },
      "OPS.md": { t: "f", c: "appd drops privileges to user 'appd'.\nThe service must NEVER run as root (run_as).\ntoken.txt must be owned by appd:appd, mode >= 640.\nIf both hold, the service will start." },
      docs: { "OPS.md": { t: "f", c: "appd drops privileges to user 'appd'.\nThe service must NEVER run as root (run_as).\ntoken.txt must be owned by appd:appd, mode >= 640.\nIf both hold, the service will start." } },
    } },
    var: { log: {
      syslog: { t: "f", c: "Sep 24 09:41:58 host appd[4021]: config error: run_as=root is not allowed\nSep 24 09:41:58 host appd[4021]: cannot open /var/lib/appd/token: Permission denied\nSep 24 09:41:58 host systemd[1]: appd.service: main process exited, code=exited, status=1/FAILURE" },
      "appd.log": { t: "f", c: "09:41:58 FATAL run_as=root refused\n09:41:58 ERROR open token: permission denied\n09:41:58 EXIT status=1\n09:43:00 (service down)" },
    },
      lib: { appd: {
        "token.txt": { t: "f", c: "abc123-verify", owner: "root", mode: "600" },
      } },
    },
    usr: { bin: { appd: { t: "f", c: "ELF 64-bit executable (static)" } } },
    tmp: {},
    home: { user: {} },
    root: {},
  };

  function nodeAt(parts) {
    let n = F;
    for (const p of parts) {
      if (n && typeof n === "object" && n[p]) n = n[p]; else return null;
    }
    return n;
  }
  function resolve(raw) {
    let p = raw.trim();
    let parts;
    if (p === "~") { p = "/home/user"; }
    if (!p.startsWith("/")) p = (cwd === "/" ? "/" : cwd) + "/" + p;
    const stack = [];
    for (const seg of p.split("/")) {
      if (!seg || seg === ".") continue;
      if (seg === "..") { if (stack.length) stack.pop(); continue; }
      stack.push(seg);
    }
    return stack;
  }
  function norm(stack) { return stack.length ? "/" + stack.join("/") : "/"; }

  /* ---------------- rendering ---------------- */
  const inline = document.getElementById("tui-inline");
  function print(s, cls) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    if (typeof s === "string") div.textContent = s; else div.appendChild(s);
    if (inline && inline.parentNode === out) out.insertBefore(div, inline);
    else out.appendChild(div);
    out.scrollTop = out.scrollHeight;
  }
  function typeLine(s, cls, cb) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    if (inline && inline.parentNode === out) out.insertBefore(div, inline);
    else out.appendChild(div);
    let i = 0;
    const iv = setInterval(() => {
      div.textContent = s.slice(0, ++i);
      out.scrollTop = out.scrollHeight;
      if (i >= s.length) { clearInterval(iv); if (cb) cb(); }
    }, 20);
  }
  function syncWidth() { input.style.width = Math.max(2, input.value.length + 1) + "ch"; }

  function rickroll() {
    out.innerHTML = "";
    if (inline) out.appendChild(inline);
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

  /* ---------------- matrix ---------------- */
  function startMatrix() {
    mode = "matrix";
    mstep = 0;
    typeLine("wake up, neo...", "tui-ok", () => {
      typeLine("the matrix has you.", "tui-ok", () => {
        typeLine("follow the white rabbit.", "tui-ok", () => {
          typeLine("knock, knock.", "tui-ok", () => {
            mstep = 1;
            print("", "tui-out");
            typeLine("red pill or blue pill?", "tui-ok", () => input.focus());
          });
        });
      });
    });
  }
  function matrixAnswer(raw) {
    const a = raw.toLowerCase().trim();
    if (mstep === 1) {
      if (a === "red") {
        mstep = 2;
        print("", "tui-out");
        typeLine("there is no spoon.", "tui-ok", () => {
          typeLine("a transmission arrives, caesar +3:", "tui-ok", () => {
            typeLine("WKH PDWULA", "tui-ok", () => input.focus());
          });
        });
      } else if (a === "blue") rickroll();
      else print("that's not a pill.", "tui-err");
    } else if (mstep === 2) {
      if (a.replace(/\s+/g, "") === "thematrix") {
        woke = true; mstep = 0; mode = "shell";
        typeLine("welcome to the real world.", "tui-ok", () => {
          typeLine("you are the one.", "tui-ok", () => {
            typeLine("(there is more in here. keep digging.)", "tui-ok", () => {
              print(PROMPT + " $ ", "tui-cmd");
              setTimeout(() => { if (!journeyStarted) beginJourney(); }, 1500);
            });
          });
        });
      } else rickroll();
    }
  }

  /* ---------------- journey ---------------- */
  function beginJourney() {
    journeyStarted = true;
    print("", "tui-out");
    print("[systemd] appd.service: main process exited, code=exited, status=1/FAILURE", "tui-err");
    print("[systemd] appd.service: Failed with result 'exit-code'.", "tui-err");
    typeLine("journalctl is your friend.", "tui-out", () => input.focus());
  }

  function listDir(visible) {
    const n = nodeAt(cwd.split("/").filter(Boolean));
    if (!n) return [];
    return Object.keys(n).filter((k) => visible || !k.startsWith("."));
  }
  function fmtLs(baseStack, names, long) {
    return names.map((k) => {
      const n = nodeAt(baseStack.concat([k]));
      const isDir = n && !n.t;
      if (long) {
        const owner = "root root";
        const mode = isDir ? "drwxr-xr-x" : (n.owner === "appd" ? "-rw-r-----" : "-rw-r--r--");
        return mode + " 1 " + owner + "  " + k + (isDir ? "/" : "");
      }
      return k + (isDir ? "/" : "");
    }).join("  ");
  }

  function handle(cmdRaw) {
    const cmd = cmdRaw.trim();
    if (!cmd) return;
    const m = cmd.match(/^(\S+)\s*(.*)$/);
    const verb = m[1], rest = m[2];

    if (verb === "clear") { out.innerHTML = ""; if (inline) out.appendChild(inline); return; }
    if (/^daemon-up$/.test(verb + " " + rest) || verb === "daemon-up") {
      if (restarted) return finish();
      print("not yet. the service is still down.", "tui-err");
      return;
    }

    switch (verb) {
      case "pwd": print(cwd, "tui-out"); return;
      case "cd": {
        const target = rest || "/";
        const parts = resolve(target);
        const n = nodeAt(parts);
        if (n && !n.t) { cwd = norm(parts); }
        else print("cd: no such directory: " + target, "tui-err");
        return;
      }
      case "ls": {
        const long = /\-la(?!\w)/.test(rest) || /\-l/.test(rest) || /\-a/.test(rest);
        const target = rest.replace(/\-+[la]+/g, "").trim() || ".";
        const parts = resolve(target);
        const n = nodeAt(parts);
        if (!n || n.t) { print("ls: cannot access '" + target + "': No such file or directory", "tui-err"); return; }
        const names = Object.keys(n);
        const showHidden = /\-a/.test(rest);
        print(fmtLs(parts, names.filter((k) => showHidden || !k.startsWith(".")), long), "tui-out");
        if (showHidden && cwd === "/") print(".  ..  root  usr  tmp  var  etc  home", "tui-out");
        return;
      }
      case "cat": case "more": case "less": {
        const parts = resolve(rest);
        const n = nodeAt(parts);
        if (!n || !n.t) { print(verb + ": " + rest + ": No such file or directory", "tui-err"); return; }
        print(n.c, "tui-out");
        return;
      }
      case "tail": {
        const parts = resolve(rest.replace(/^(-n\s*\d+|-n\d+)\s*/g, ""));
        const n = nodeAt(parts);
        if (!n || !n.t) { print("tail: " + rest + ": No such file", "tui-err"); return; }
        print(n.c.split("\n").slice(-3).join("\n"), "tui-out");
        return;
      }
      case "grep": {
        const mm = rest.match(/^'?([^']+)'?[ ]+(\S+)$/);
        if (!mm) { print("usage: grep <pattern> <file>", "tui-err"); return; }
        const parts = resolve(mm[2]);
        const n = nodeAt(parts);
        if (!n || !n.t) { print("grep: " + mm[2] + ": No such file", "tui-err"); return; }
        n.c.split("\n").forEach((l, i) => { if (l.toLowerCase().includes(mm[1].toLowerCase())) print(norm(parts) + ":" + (i + 1) + ":" + l, "tui-out"); });
        return;
      }
      case "cp": {
        const mm = rest.split(/\s+/);
        if (mm.length < 2) { print("cp: missing destination file operand", "tui-err"); return; }
        const src = resolve(mm[0]), dst = resolve(mm[1]);
        const s = nodeAt(src);
        if (!s || !s.t) { print("cp: cannot stat '" + mm[0] + "': No such file", "tui-err"); return; }
        const d = nodeAt(dst);
        if (d && !d.t) { print("cp: '" + mm[1] + "' is a directory", "tui-err"); return; }
        const parent = resolve(mm[1]).slice(0, -1);
        const pn = nodeAt(parent);
        if (!pn) { print("cp: cannot create '" + mm[1] + "': No such file or directory", "tui-err"); return; }
        const name = resolve(mm[1]).pop();
        pn[name] = { t: "f", c: s.c, owner: "root", mode: "644" };
        if (norm(dst) === "/etc/appd/appd.conf" && s.c.includes("run_as = appd")) { configFixed = true; }
        print("cp: " + norm(dst) + " copied", "tui-ok");
        return;
      }
      case "chown": {
        const mm = rest.split(/\s+/);
        if (mm.length < 2) { print("chown: missing operand", "tui-err"); return; }
        const parts = resolve(mm[1]);
        const n = nodeAt(parts);
        if (!n) { print("chown: cannot access '" + mm[1] + "': No such file", "tui-err"); return; }
        if (mm[0].startsWith("appd:")) { n.owner = "appd"; }
        if (norm(parts) === "/var/lib/appd/token.txt" && n.owner === "appd") tokenFixed = true;
        print("chown: " + mm[0] + " " + norm(parts), "tui-ok");
        return;
      }
      case "chmod": {
        const mm = rest.split(/\s+/);
        if (mm.length < 2) { print("chmod: missing operand", "tui-err"); return; }
        const parts = resolve(mm[1]);
        const n = nodeAt(parts);
        if (!n) { print("chmod: cannot access '" + mm[1] + "': No such file", "tui-err"); return; }
        n.mode = mm[0];
        if (norm(parts) === "/var/lib/appd/token.txt" && /\d/.test(mm[0]) && parseInt(mm[0], 8) >= 640) tokenFixed = true;
        print("chmod: mode " + mm[0] + " on " + norm(parts), "tui-ok");
        return;
      }
      case "mv": {
        const mm = rest.split(/\s+/);
        if (mm.length < 2) { print("mv: missing destination file operand", "tui-err"); return; }
        const src = resolve(mm[0]), s = nodeAt(src);
        if (!s) { print("mv: cannot stat '" + mm[0] + "': No such file", "tui-err"); return; }
        const pn = nodeAt(resolve(mm[1]).slice(0, -1));
        if (!pn) { print("mv: cannot move", "tui-err"); return; }
        pn[resolve(mm[1]).pop()] = s;
        nodeAt(src) && delete nodeAt(resolve(mm[0]).slice(0, -1))[resolve(mm[0]).pop()];
        if (resolve(mm[1]).pop() === "appd.conf" && s.c.includes("run_as = appd")) configFixed = true;
        print("mv: moved", "tui-ok");
        return;
      }
      case "systemctl": {
        const mm = rest.split(/\s+/);
        const sub = mm[0];
        if (sub === "status") {
          print(restarted ? "appd.service - app daemon\n  Active: active (running)" : "appd.service - app daemon\n  Active: failed (Result: exit-code)", restarted ? "tui-ok" : "tui-err");
          return;
        }
        if (sub === "is-active") { print(restarted ? "active" : "failed", restarted ? "tui-ok" : "tui-err"); return; }
        if (sub === "restart") {
          if (!configFixed && !tokenFixed) {
            print("Job for appd.service failed: config error (run_as) and token permission denied.", "tui-err");
            print("read the log, read the manual: /etc/appd/OPS.md", "tui-err");
          } else if (!configFixed) {
            print("Job for appd.service failed: run_as=root is not allowed.", "tui-err");
          } else if (!tokenFixed) {
            print("Job for appd.service failed: cannot open /var/lib/appd/token: Permission denied.", "tui-err");
          } else {
            restarted = true;
            print("Restarting appd.service...", "tui-out");
            setTimeout(() => {
              print("appd.service started as user appd.", "tui-ok");
              print("Sep 24 09:43:12 host appd[4156]: all checks passed", "tui-ok");
              print("Sep 24 09:43:12 host appd[4156]: flag: DAEMON-UP", "tui-ok");
            }, 500);
          }
          return;
        }
        print("systemctl: unknown subcommand '" + sub + "' for appd.service", "tui-err");
        return;
      }
      case "journalctl": {
        if (rest.startsWith("-u appd") || rest === "-u appd" || rest === "-xeu appd" || rest === "") {
          if (rest === "") { print("usage: journalctl -u appd", "tui-err"); return; }
          print("-- Logs begin at Mon 2026-09-21, end at now. --", "tui-out");
          print("Sep 24 09:41:58 host appd[4021]: /usr/bin/appd: config error: run_as=root is not allowed", "tui-err");
          print("Sep 24 09:41:58 host appd[4021]: cannot open /var/lib/appd/token: Permission denied", "tui-err");
          print("Sep 24 09:41:58 host systemd[1]: appd.service: main process exited, code=exited, status=1/FAILURE", "tui-err");
          print("Sep 24 09:41:58 host systemd[1]: Unit entered failed state.", "tui-err");
        } else { print("journalctl: option mismatch: try journalctl -u appd", "tui-err"); }
        return;
      }
      case "find": {
        if (rest === "/ -name appd.conf") { print("/etc/appd/appd.conf", "tui-out"); return; }
        print("find: try: find / -name appd.conf", "tui-err"); return;
      }
      case "whoami": print("firas", "tui-ok"); return;
      default: print("command not found: " + verb, "tui-err");
    }
  }

  function finish() {
    typeLine("you cracked it.", "tui-ok", () => {
      typeLine("the daemon is serving again.", "tui-ok", () => {
        typeLine("welcome to the real world, part 2.", "tui-out");
      });
    });
  }

  input.addEventListener("input", syncWidth);
  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const v = input.value;
      if (/\brm\b/i.test(v)) {
        print(PROMPT + " $ " + v, "tui-cmd");
        input.value = ""; syncWidth();
        rickroll();
        return;
      }
      if (mode === "matrix") { input.value = ""; syncWidth(); matrixAnswer(v); return; }
      if (!woke) { input.value = ""; syncWidth(); startMatrix(); return; }
      input.value = ""; syncWidth();
      print(PROMPT + " $ " + v, "tui-cmd");
      handle(v);
    } else if (e.key === "Tab") e.preventDefault();
  });
  el.addEventListener("click", () => {
    if (rick) { rick = false; out.innerHTML = ""; }
    try { input.focus(); } catch (e) {}
  });

  syncWidth();
  input.focus();
})();
