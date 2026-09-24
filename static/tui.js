/* groundsada TUI v6 — Matrix intro → admin debugging journey. No games.
   Wake up Neo → solve the cipher → the daemon is broken → fix it or walk away. */
(function () {
  const el = document.getElementById("tui");
  if (!el) return;
  const out = el.querySelector(".tui-body");
  const input = el.querySelector(".tui-input");
  const prompt = "firas@groundsada";

  let mode = "shell";        // shell | matrix | journey
  let rick = false, woke = false;
  let mstep = 0;
  let configFixed = false;   // cp done?
  let restarted = false;     // systemctl restart done?
  let journeyStarted = false;

  function print(s, cls) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    if (typeof s === "string") div.textContent = s; else div.appendChild(s);
    out.appendChild(div);
    out.scrollTop = out.scrollHeight;
  }
  function typeLine(s, cls, cb) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    out.appendChild(div);
    let i = 0;
    const iv = setInterval(() => {
      div.textContent = s.slice(0, ++i);
      out.scrollTop = out.scrollHeight;
      if (i >= s.length) { clearInterval(iv); if (cb) cb(); }
    }, 22);
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

  /* ---------- 1. the matrix ---------- */
  function startMatrix() {
    mode = "matrix";
    mstep = 0;
    typeLine("wake up, neo...", "tui-ok", () => {
      typeLine("the matrix has you.", "tui-ok", () => {
        typeLine("follow the white rabbit.", "tui-ok", () => {
          typeLine("knock, knock.", "tui-ok", () => {
            mstep = 1;
            print("", "tui-out");
            typeLine("red pill or blue pill?", "tui-ok", () => {
              print(prompt + " $ ", "tui-cmd");
              input.focus();
            });
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
            typeLine("WKH PDWULA", "tui-ok", () => {
              print(prompt + " $ ", "tui-cmd");
              input.focus();
            });
          });
        });
      } else if (a === "blue") {
        rickroll();
      } else {
        print("that's not a pill.", "tui-err");
        print(prompt + " $ ", "tui-cmd");
      }
    } else if (mstep === 2) {
      if (a.replace(/\s+/g, "") === "thematrix") {
        woke = true;
        mstep = 0;
        typeLine("welcome to the real world.", "tui-ok", () => {
          typeLine("you are the one.", "tui-ok", () => {
            typeLine("(there is more in here. keep digging.)", "tui-ok", () => {
              mode = "shell";
              print(prompt + " $ ", "tui-cmd");
              setTimeout(() => { if (!journeyStarted) beginJourney(); }, 1600);
            });
          });
        });
      } else {
        rickroll();
      }
    }
  }

  /* ---------- 2. the journey: appd lost its config ---------- */
  function beginJourney() {
    journeyStarted = true;
    print("", "tui-out");
    typeLine("[systemd] appd.service: main process exited, code=exited, status=1/FAILURE", "tui-err", () => {
      typeLine("[systemd] appd.service: Failed with result 'exit-code'.", "tui-err", () => {
        print(prompt + " $ ", "tui-cmd");
        input.focus();
      });
    });
  }

  const JOURNEY = {
    "journalctl -u appd": () => {
      print("-- Logs begin at Mon 2026-09-21, end at now. --", "tui-out");
      print("Sep 24 09:41:58 host appd[4021]: /usr/bin/appd --config /etc/appd.conf: No such file or directory", "tui-err");
      print("Sep 24 09:41:58 host appd[4021]: main: re-exec failed: config not found", "tui-err");
      print("Sep 24 09:41:58 host systemd[1]: appd.service: main process exited, code=exited, status=1/FAILURE", "tui-err");
      print("Sep 24 09:41:58 host systemd[1]: Unit entered failed state.", "tui-err");
    },
    "ls -la /etc/appd/": () => {
      print("total 20", "tui-out");
      print("drwxr-xr-x  2 root root 4096 Sep 23 18:12 .", "tui-out");
      print("drwxr-xr-x  7 root root 4096 Sep 23 18:12 ..", "tui-out");
      print("-rw-r--r--  1 root root 1024 Sep 23 18:10 appd.conf.bak", "tui-out");
      print("-rw-r--r--  1 root root  512 Sep 23 18:09 appd.conf.main", "tui-out");
    },
    "cp /etc/appd/appd.conf.main /etc/appd.conf": () => {
      configFixed = true;
      print("cp: /etc/appd.conf copied", "tui-ok");
    },
    "systemctl restart appd": () => {
      if (!configFixed) {
        print("Job for appd.service failed because the control process exited with error code.", "tui-err");
        print('See "systemctl status appd.service" and "journalctl -xeu appd.service" for details.', "tui-err");
      } else {
        restarted = true;
        print("Restarting appd.service...", "tui-out");
        print("appd.service restarted successfully.", "tui-ok");
        setTimeout(() => {
          print("Sep 24 09:43:12 host appd[4156]: config loaded from /etc/appd.conf", "tui-ok");
          print("Sep 24 09:43:12 host appd[4156]: flag: FIXED-THE-CONFIG", "tui-ok");
          print(prompt + " $ ", "tui-cmd");
        }, 600);
      }
      if (!configFixed) print(prompt + " $ ", "tui-cmd");
    },
    "systemctl is-active appd": () => {
      print(restarted ? "active" : "failed", restarted ? "tui-ok" : "tui-err");
    },
    "cat /etc/appd.conf": () => {
      if (configFixed) {
        print("run_as = appd", "tui-out");
        print("max_restarts = 3", "tui-out");
        print("log_level = info", "tui-out");
      } else {
        print("cat: /etc/appd.conf: No such file or directory", "tui-err");
      }
    },
    "whoami": () => {
      print("firas", "tui-ok");
    },
  };

  function finish() {
    typeLine("you cracked it.", "tui-ok", () => {
      typeLine("the daemon is serving again.", "tui-ok", () => {
        typeLine("welcome to the real world, part 2.", "tui-out", () => {
          print(prompt + " $ ", "tui-cmd");
        });
      });
    });
  }

  function run(cmdRaw) {
    print(prompt + " $ " + cmdRaw, "tui-cmd");
    const cmd = cmdRaw.trim().replace(/\s+/g, " ");
    const c = cmd.toLowerCase();

    if (/^rm/.test(c)) { rickroll(); return; }
    if (c === "clear") { out.innerHTML = ""; return; }
    if (/^fixed-the-config$/.test(c)) { if (woke) finish(); return; }

    // journey commands (only active after the matrix solve)
    if (woke && JOURNEY[cmd]) { JOURNEY[cmd](); return; }
    if (woke && cmd.startsWith("journalctl")) { JOURNEY["journalctl -u appd"](); return; }

    if (cmd === "red pill" || cmd === "blue pill" || cmd === "red" || cmd === "blue") {
      print("the pills were earlier.", "tui-err");
      return;
    }
    print("command not found: " + cmd, "tui-err");
    print(prompt + " $ ", "tui-cmd");
  }

  input.addEventListener("input", syncWidth);
  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const v = input.value;
      if (/^rm/i.test(v.trim())) {
        print(prompt + " $ " + v, "tui-cmd");
        input.value = ""; syncWidth();
        rickroll();
        return;
      }
      if (mode === "matrix") {
        input.value = ""; syncWidth();
        matrixAnswer(v);
        return;
      }
      if (!woke) {
        // first Enter ever: wake neo (even empty)
        input.value = ""; syncWidth();
        startMatrix();
        return;
      }
      input.value = ""; syncWidth();
      run(v);
    } else if (e.key === "Tab") {
      e.preventDefault();
    }
  });

  el.addEventListener("click", () => {
    if (rick) { rick = false; out.innerHTML = ""; mode = "shell"; }
    try { input.focus(); } catch (e) {}
  });

  syncWidth();
  input.focus();
})();
