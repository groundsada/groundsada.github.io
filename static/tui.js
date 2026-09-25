/* groundsada TUI v10 ,  Matrix intro → Agent Race → SMITH. Win = rewards. */
(function () {
  const el = document.getElementById("tui");
  if (!el) return;
  const out = el.querySelector(".tui-body");
  const input = el.querySelector(".tui-input");
  const inline = document.getElementById("tui-inline");
  const PROMPT = "firas@groundsada";

  let woke = false, rick = false, mstep = 0, mode = "shell";
  let strikes = 0, agentDown = false, smithPhase = false, smithDown = false;
  let act3 = 0; // 0=off 1=decipher 2=word 3=riddle 4=done
  let act4 = 0, gateOpen = false, rabbitPranked = false, rabbitLoose = false;
  const AGENT = 1337, DECOYS = { 2041: "appd-worker", 3120: "monitor", 4242: "logger" };
  const SMITH = { 4001: "copy", 4002: "original", 4003: "copy", 4004: "copy" };

  const F = {
    etc: { "passwd": { t: "f", c: "root:x:0:0:root:/root:/bin/bash\nfiras:x:1000:1000:firas:/home/user:/bin/bash\nappd:x:1001:1001:appdaemon:/srv/appd:/usr/sbin/nologin" },
           "shadow": { t: "f", c: "you were never supposed to open this." } },
    opt: { machines: { "agent.core": { t: "f", c: "ELF executable (malicious)" },
                       "README": { t: "f", c: "the real one links to /opt/machines.\nthe decoys link to /usr/bin.\nfollow the exe. not the name." } },
           smith: { "root": { t: "f", c: "ELF executable (original smith)" },
                    "truth.txt": { t: "f", c: "GUR NEPUVGRPG" },
                    "journal.txt": { t: "f", c: "smith/1  -> copy\nsmith/2  -> ORIGINAL\nsmith/3  -> copy\nsmith/4  -> copy" } } },
    srv: { gate: { "checksum.txt": { t: "f", c: "3f4c9b68a1d2e7f0" },
                            "pass.bin": { t: "f", c: "the key to the gate" },
                            "decoy.bin": { t: "f", c: "decoy data" },
                            "manifests.txt": { t: "f", c: "the door opens for 3f4c9b68a1d2e7f0.\nfind the file that matches. sha256sum will tell the truth." } } },
    var: { run: {}, log: { "watchdog.log": { t: "f", c: "09:41:50 watchdog: agent.core detected (pid 1337)\n09:42:10 watchdog: agent.core respawn=active\n09:42:40 watchdog: recompute pid on respawn\n09:44:10 watchdog: SMITH DETECTED (4 instances)" } } },
    tmp: { "smith.log": { t: "f", c: "the original laughs last: smith/2" } },
    usr: { bin: {} }, home: { user: {} }, root: {},
  };

  function nodeAt(parts) {
    let n = F;
    for (const p of parts) { if (n && typeof n === "object" && n[p]) n = n[p]; else return null; }
    return n;
  }
  function resolve(raw) {
    let p = raw.trim();
    if (p === "~") p = "/home/user";
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
  let cwd = "/";

  function print(s, cls) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    if (typeof s === "string") div.textContent = s; else div.appendChild(s);
    if (inline && inline.parentNode === out) out.insertBefore(div, inline); else out.appendChild(div);
    out.scrollTop = out.scrollHeight;
  }
  function typeLine(s, cls, cb) {
    const div = document.createElement("div");
    div.className = "tui-line" + (cls ? " " + cls : "");
    if (inline && inline.parentNode === out) out.insertBefore(div, inline); else out.appendChild(div);
    let i = 0;
    const iv = setInterval(() => {
      div.textContent = s.slice(0, ++i);
      out.scrollTop = out.scrollHeight;
      if (i >= s.length) { clearInterval(iv); if (cb) cb(); }
    }, 20);
  }
  function syncWidth() { input.style.width = Math.max(2, input.value.length + 1) + "ch"; }
  function clearBody() { out.innerHTML = ""; if (inline) out.appendChild(inline); }

  function rickroll(label) {
    clearBody();
    if (label) print(label, "tui-err");
    const wrap = document.createElement("div");
    wrap.className = "tui-rick";
    const ifr = document.createElement("iframe");
    ifr.src = "https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ?autoplay=1";
    ifr.allow = "autoplay; encrypted-media; fullscreen";
    ifr.allowFullscreen = true;
    ifr.title = "rick";
    wrap.appendChild(ifr);
    const label2 = document.createElement("div");
    label2.className = "tui-rick__label";
    label2.textContent = "never gonna give you up ,  click the terminal to back out";
    wrap.appendChild(label2);
    out.appendChild(wrap);
    rick = true;
    out.scrollTop = out.scrollHeight;
  }

  /* ---------- strikes ---------- */
  function strike(why) {
    strikes++;
    el.classList.remove("tui--shake");
    void el.offsetWidth;
    el.classList.add("tui--shake");
    print("⚠ STRIKE " + strikes + "/3 ,  " + why, "tui-strike");
    if (strikes >= 3) {
      typeLine("the machines found you.", "tui-err", () => {
        typeLine("you are not the one.", "tui-err", () => setTimeout(() => rickroll(), 700));
      });
    }
  }
  const TRAPS = [
    [/^pkill\b/, "sweeping kills hit the wrong process first."],
    [/^killall\b/, "killall is a sledgehammer. you nailed a decoy (and the walls)."],
    [/^kill\s+-?-?9?\s*1\b/, "you don't kill the init. ever."],
    [/^systemctl\s+stop\b/, "stopping the wrong service set off the alarm."],
    [/^(reboot|shutdown|poweroff|halt)\b/, "the environment noticed."],
    [/^(su|sudo)\b/, "credentials? the machines were listening."],
    [/^chmod\s+777\s*\/$/, "777 on root. bold. wrong."],
    [/^cat\s+\/etc\/shadow/, "you were never supposed to open that."],
  ];
  function trapMatch(cmd) {
    for (const [re, why] of TRAPS) if (re.test(cmd)) return why;
    return null;
  }

  /* ---------- matrix ---------- */
  function startMatrix() {
    mode = "matrix"; mstep = 0;
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
        typeLine("there is no spoon.", "tui-ok", () => {
          typeLine("a transmission arrives, caesar +3:", "tui-ok", () => {
            typeLine("WKH PDWULA", "tui-ok", () => input.focus());
          });
        });
      } else if (a === "blue") rickroll("blue. the machines got you early.");
      else print("that's not a pill.", "tui-err");
    } else if (mstep === 2) {
      if (a.replace(/\s+/g, "") === "thematrix") {
        woke = true; mstep = 0; mode = "shell";
        typeLine("welcome to the real world.", "tui-ok", () => {
          typeLine("you are the one.", "tui-ok", () => {
            typeLine("(there is more in here. keep digging.)", "tui-ok", () => {
              setTimeout(() => {
                print("[watchdog] agent.core detected. respawn: active.", "tui-err");
                input.focus();
              }, 1200);
            });
          });
        });
      } else rickroll("decrypted wrong. the machines found you.");
    }
  }

  /* ---------- phase 2: smith ---------- */
  function spawnSmith() {
    smithPhase = true;
    typeLine("mr. anderson...", "tui-err", () => {
      typeLine("we meet again.", "tui-err", () => {
        typeLine("four of me walk this system. one is original. free the right one.", "tui-err", () => {
          print("[watchdog] smith detected (4 instances).", "tui-err");
        });
      });
    });
  }

  /* ---------- command helpers ---------- */
  function psList() {
    if (smithPhase && smithDown) {
      print("  PID TTY          TIME CMD", "tui-out");
      print(" 2041 pts/0    00:00:02 appd-worker", "tui-out");
      print(" 3120 pts/1    00:00:01 monitor", "tui-out");
      print(" 4242 pts/1    00:00:00 logger", "tui-out");
      print("smith: dissolved. no copies remain.", "tui-ok");
      return;
    }
    if (smithPhase) {
      print("  PID TTY          TIME CMD", "tui-out");
      print(" 4001 pts/0    00:00:01 smith", "tui-err");
      print(" 4002 pts/0    00:00:02 smith", "tui-err");
      print(" 4003 pts/1    00:00:01 smith", "tui-err");
      print(" 4004 pts/1    00:00:01 smith", "tui-err");
      print(" 2041 pts/0    00:00:02 appd-worker", "tui-out");
      print(" 3120 pts/1    00:00:01 monitor", "tui-out");
      return;
    }
    if (agentDown) { psIdle(); return; }
    print("  PID TTY          TIME CMD", "tui-out");
    print(" 1337 pts/0    00:00:45 agent.core", "tui-err");
    print(" 2041 pts/0    00:00:02 appd-worker", "tui-out");
    print(" 3120 pts/1    00:00:01 monitor", "tui-out");
    print(" 4242 pts/1    00:00:00 logger", "tui-out");
  }
  function psIdle() {
    print("  PID TTY          TIME CMD", "tui-out");
    print(" 2041 pts/0    00:00:02 appd-worker", "tui-out");
    print(" 3120 pts/1    00:00:01 monitor", "tui-out");
    print(" 4242 pts/1    00:00:00 logger", "tui-out");
  }
  function procInfo(pid, what) {
    if (smithPhase && SMITH[pid]) {
      const kind = SMITH[pid];
      if (what === "comm") return "smith";
      if (what === "cmdline") return kind === "original" ? "/opt/smith/root --singular" : "/usr/bin/smith --copy";
      if (what === "exe") return kind === "original" ? "/opt/smith/root" : "/usr/bin/smith";
      if (what === "status") return "Name:\tsmith\nInst:\t" + kind + "\nPid:\t" + pid + (kind === "original" ? "\nActually:\thim" : "\nActually:\tan echo");
      return "entry not found";
    }
    if (String(pid) === String(AGENT) && !agentDown) {
      if (what === "comm") return "agent.core";
      if (what === "cmdline") return "/opt/machines/agent.core --respawn";
      if (what === "exe") return "/opt/machines/agent.core";
      if (what === "status") return "Name:\tagent.core\nState:\tR (running)\nPid:\t1337\nRespawn:\tyes";
      return "entry not found";
    }
    if (DECOYS[pid]) {
      if (what === "comm") return DECOYS[pid];
      if (what === "exe") return "/usr/bin/" + DECOYS[pid];
      if (what === "cmdline") return "/usr/bin/" + DECOYS[pid];
      if (what === "status") return "Name:\t" + DECOYS[pid] + "\nState:\tS (sleeping)\nPid:\t" + pid;
      return "entry not found";
    }
    return "no such process";
  }

  function handle(cmdRaw) {
    const cmd = cmdRaw.trim();
    if (!cmd) return;
    const parts = cmd.split(/\s+/);
    const verb = parts[0];

    if (verb === "clear") { clearBody(); return; }
    if (/^smith-down$/.test(cmd)) {
      if (smithDown) {
        if (act3 === 0) startAct3();
        else print("act iii is on. no repeats.", "tui-err");
        return;
      }
      print("smith still has copies to spare.", "tui-err"); return;
    }
    if (/^agent-down$/.test(cmd)) {
      if (agentDown) return finish1();
      print("the agent is still breathing.", "tui-err"); return;
    }
    if (/\brm\b/i.test(cmd)) { rickroll(); return; }
    if (/^reality$/.test(cmd)) return reality();
    const why = trapMatch(cmd);
    if (why) { strike(why); return; }

    if (/^systemctl\s+start\b/.test(cmd)) {
      if (gateOpen) { print("gate: already open.", "tui-out"); return; }
      const kp = ["var", "run", "gate.pass"];
      if (act4 === 1 && nodeAt(kp) && nodeAt(kp).t) {
        gateOpen = true;
        print("gate: opened. flag: GATE-OPEN.", "tui-ok");
        typeLine("the machines have been outplayed. the exit is open...", "tui-out", () => {
          typeLine("and there, in the hero, the white rabbit. one more step. chase it.", "tui-ok", () => finish4());
        });
      } else {
        print("gate: key missing (need /var/run/gate.pass)", "tui-err");
      }
      return;
    }

    switch (verb) {
      case "pwd": print(cwd, "tui-out"); return;
      case "status": {
        let parts = [];
        parts.push("agent.core: " + (agentDown ? "dead" : "active"));
        parts.push("smith: " + (smithDown ? "dissolved" : smithPhase ? "active (4 copies)" : "not yet"));
        parts.push("strikes: " + strikes + "/3");
        parts.push(rabbitLoose ? "rabbit: loose" : "rabbit: hiding");
        print(parts.join(" | "), "tui-out");
        return;
      }
      case "cd": {
        const t = parts[1] || "/";
        const n = nodeAt(resolve(t));
        if (n && !n.t) cwd = norm(resolve(t));
        else print("cd: no such directory: " + t, "tui-err");
        return;
      }
      case "ls": {
        const target = parts.slice(1).filter((x) => !x.startsWith("-")).join("") || ".";
        const n = nodeAt(resolve(target));
        if (!n || n.t) { print("ls: cannot access '" + target + "': No such file or directory", "tui-err"); return; }
        print(Object.keys(n).filter((k) => !k.startsWith(".")).map((k) => k + (n[k] && !n[k].t ? "/" : "")).join("  "), "tui-out");
        return;
      }
      case "cat": {
        const mm = parts[1] || "";
        const pproc = mm.match(/^\/proc\/(\d+)\/(comm|cmdline|status|exe)$/);
        if (pproc) { print(procInfo(pproc[1], pproc[2]), "tui-out"); return; }
        const n = nodeAt(resolve(mm));
        if (!n || !n.t) { print("cat: " + mm + ": No such file or directory", "tui-err"); return; }
        print(n.c, "tui-out");
        return;
      }
      case "readlink": {
        const mm = (parts[1] || "").match(/^\/proc\/(\d+)\/(exe|cmdline)$/);
        if (mm) { print(procInfo(mm[1], mm[2]), "tui-out"); return; }
        print("readlink: no such target", "tui-err");
        return;
      }
      case "ps": psList(); return;
      case "kill": {
        const pid = parts[parts.length - 1] || "";
        if (!/^\d+$/.test(pid)) { print("usage: kill <pid>", "tui-err"); return; }
        if (smithPhase) {
          if (pid === "4002") {
            smithDown = true;
            print("----", "tui-strike");
            print("smith: *dissolves* ...", "tui-ok");
            print("the copies fall silent. ps will confirm.", "tui-ok");
            print("flag: SMITH-DOWN ,  type it to collect.", "tui-ok");
            print("----", "tui-strike");
            return;
          }
          if (SMITH[pid]) { strike("that was just an echo. smith of your own doubt."); return; }
          print("kill: (" + pid + ") - no such process", "tui-err");
          return;
        }
        if (pid === String(AGENT)) {
          agentDown = true;
          print("----", "tui-strike");
          print("agent.core terminated. respawn stopped.", "tui-ok");
          print("flag: AGENT-DOWN ,  but smith stirs...", "tui-ok");
          print("----", "tui-strike");
          setTimeout(spawnSmith, 1400);
          return;
        }
        if (DECOYS[pid]) { strike("that was " + DECOYS[pid] + ". an innocent. (and not the agent)"); return; }
        print("kill: (" + pid + ") - no such process", "tui-err");
        return;
      }
      case "tail": {
        const n = nodeAt(resolve(parts.slice(1).join(" ").replace(/^(-n\s*\d+|-n\d+)\s*/, "")));
        if (!n || !n.t) { print("tail: no such file", "tui-err"); return; }
        print(n.c.split("\n").slice(-3).join("\n"), "tui-out");
        return;
      }
      case "sha256sum": {
        const f = parts.slice(1).join(" ").replace(/\*$/, "") || "";
        if (f.indexOf("pass.bin") >= 0) print("3f4c9b68a1d2e7f0  " + f, "tui-ok");
        else if (f.indexOf("decoy.bin") >= 0) print("9d2a77e1c4b6f3a8  " + f, "tui-err");
        else { const n = nodeAt(resolve(f)); if (!n || !n.t) { print("sha256sum: " + f + ": No such file", "tui-err"); } else print("0e1b2c3d4e5f6a7b  " + f, "tui-out"); }
        return;
      }
      case "cp": {
        const src = parts[1] || "", dst = parts[2] || "";
        const sn = nodeAt(resolve(src));
        if (!sn || !sn.t) { print("cp: cannot stat '" + src + "': No such file", "tui-err"); return; }
        const pr = resolve(dst).slice(0, -1);
        const pn = nodeAt(pr);
        if (!pn || pn.t) { print("cp: cannot create '" + dst + "': directory missing", "tui-err"); return; }
        pn[resolve(dst)[resolve(dst).length - 1]] = { t: "f", c: sn.c };
        print("copied " + src + " -> " + dst, "tui-ok");
        return;
      }
      case "grep": {
        const pat = (parts[1] || "").replace(/^'|'$/g, "");
        const f = parts[2] || "";
        const n = nodeAt(resolve(f));
        if (!n || !n.t) { print("grep: " + f + ": No such file", "tui-err"); return; }
        n.c.split("\n").forEach((l) => { if (l.toLowerCase().includes(pat.toLowerCase())) print(l, "tui-out"); });
        return;
      }
      case "reset": {
        const r = document.querySelector(".matrix-rabbit");
        if (r) r.remove();
        rabbitLoose = false;
        print("nothing to reset. the rabbit forgets with the session.", "tui-out");
        return;
      }
      case "whoami": print("firas", "tui-ok"); return;
      case "uname": print("Linux groundsada 6.6.0-matrix", "tui-out"); return;
      default: print("command not found: " + verb, "tui-err");
    }
  }


  /* ---------- rewards ---------- */
  function startAct3() {
    act3 = 1;
    typeLine("act iii: the machines' last laugh", "tui-strike", () => {
      typeLine("they left one file before they left:", "tui-out", () => {
        typeLine("[handoff] /opt/smith/truth.txt ,  rot13.", "tui-ok", () => {
          typeLine("decode it. type the word you find.", "tui-out", () => input.focus());
        });
      });
    });
  }
  function act3Answer(raw) {
    const a = raw.toLowerCase().trim();
    if (act3 === 1) {
      if (a === "the architect" || a === "thearchitect" || a === "architect") {
        act3 = 2;
        typeLine("decoded: the architect. he says you made it this far.", "tui-ok", () => {
          typeLine("word puzzle: one more. R P H M O U E S", "tui-out", () => {
            typeLine("(type the word)", "tui-out", () => input.focus());
          });
        });
      } else print("not quite. rot13 it. type the decoded phrase.", "tui-err");
    } else if (act3 === 2) {
      if (a === "morpheus") {
        act3 = 3;
        typeLine("morpheus. the guide who started all of this.", "tui-ok", () => {
          typeLine("riddle: i am created first, adopted by no one. my death is a story ", "tui-out", () => {
            typeLine("the machine never survives. everyone fears to kill me. what is my name?", "tui-out", () => {
              typeLine("(type my name)", "tui-out", () => input.focus());
            });
          });
        });
      } else print("eight letters. the one who offered the pills.", "tui-err");
    } else if (act3 === 3) {
      if (a === "init" || a === "systemd") {
        act3 = 4;
        typeLine("init. the one you may not kill.", "tui-ok", () => {
          typeLine("the machines are gone. the architect is scheduled. morpheus nods.", "tui-ok", () => {
            typeLine("the rabbit is loose in the hero. chase it.", "tui-ok", () => {
              startAct4();
            });
          });
        });
      } else print("first pid. power. call my name.", "tui-err");
    }
  }
  function startAct4() {
    act4 = 1;
    typeLine("not yet. one more door.", "tui-out", () => {
      typeLine("[gate] an exit is open. its key is hiding. (sha256sum tells the truth)", "tui-err", () => {
        typeLine("find the file. copy it to /var/run/gate.pass. start the gate.", "tui-out", () => input.focus());
      });
    });
  }
  function finish4() {
    rabbitLoose = true;
    drawRain();
    spawnBunny();
  }
  function finish3() {
    startAct4();
  }
  function finish1() {
    if (!smithDown) { print("smith is waiting. finish the job.", "tui-err"); return; }
    startAct3();
  }
  function finish2() {
    localStorage.setItem("the-one", "1");
    typeLine("the machines have left the room.", "tui-ok", () => {
      typeLine("they were never really in it. anyway.", "tui-ok", () => {
        typeLine("follow the white rabbit. it lives in the hero now.", "tui-out", () => {
          drawRain();
          spawnBunny();
        });
      });
    });
  }
  function reality() {
    print("the rabbit moves when you reload. that is the entire prize.", "tui-ok");
  }
  function spawnBunny() {
    try {
      const host = document.querySelector(".vc-cover") || document.querySelector(".page-intro");
      if (!host || host.querySelector(".matrix-rabbit")) return;
      const b = document.createElement("div");
      b.className = "matrix-rabbit";
      b.title = "";
      b.innerHTML = '<svg width="26" height="33" viewBox="0 0 12 15" shape-rendering="crispEdges" aria-hidden="true">' +
        '<rect x="3" y="0" width="2" height="5" fill="#ff9ec2"/><rect x="7" y="0" width="2" height="5" fill="#ff9ec2"/>' +
        '<rect x="2" y="3" width="8" height="5" fill="#f6dce8"/><rect x="3" y="8" width="6" height="4" fill="#f6dce8"/>' +
        '<rect x="3" y="12" width="2" height="3" fill="#f6dce8"/><rect x="7" y="12" width="2" height="3" fill="#f6dce8"/>' +
        '<rect x="3" y="4" width="1" height="1" fill="#141414"/><rect x="8" y="4" width="1" height="1" fill="#141414"/></svg>';
      if (getComputedStyle(host).position === "static") host.style.position = "relative";
      b.style.left = (10 + Math.random() * 74) + "%";
      b.addEventListener("click", () => {
        rabbitPranked = true;
        rickroll("the rabbit was an agent. obviously. you chased it into the trap. all of it, for this.");
      });
      // it wanders. chase it.
      b.__wander = setInterval(() => {
        if (!document.body.contains(b)) { clearInterval(b.__wander); return; }
        b.style.left = (8 + Math.random() * 78) + "%";
        b.style.top = (12 + Math.random() * 70) + "%";
      }, 3200);
      b.style.top = (16 + Math.random() * 62) + "%";
      host.appendChild(b);
    } catch (e) {}
  }
  function drawRain() {
    const glyphs = "アイウエオ0123456789<>[]";
    let n = 0;
    const iv = setInterval(() => {
      if (n++ > 18) { clearInterval(iv); return; }
      let line = "";
      for (let i = 0; i < 42; i++) line += glyphs[Math.floor(Math.random() * glyphs.length)];
      print(line, "tui-ok");
    }, 55);
  }

  input.addEventListener("input", syncWidth);
  input.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      const v = input.value;
      input.value = ""; syncWidth();
      if (/\brm\b/i.test(v)) { print(PROMPT + " $ " + v, "tui-cmd"); rickroll(); return; }
      if (v.trim().toLowerCase() === "reset") {
        print(PROMPT + " $ reset", "tui-cmd");
        const rr = document.querySelector(".matrix-rabbit");
        if (rr) rr.remove();
        rabbitLoose = false;
        print("nothing to reset. the rabbit forgets with the session.", "tui-out");
        return;
      }
      if (mode === "matrix") { matrixAnswer(v); return; }
      if (!woke) { startMatrix(); return; }
      print(PROMPT + " $ " + v, "tui-cmd");
      if (act3 >= 1 && act3 <= 3 && !/^(cat|ls|cd|pwd|ps|kill|tail|grep|whoami|clear|status|readlink|uname|head)\b/.test(v.trim())) { act3Answer(v); return; }
      handle(v);
    } else if (e.key === "Tab") e.preventDefault();
  });
  el.addEventListener("click", () => {
    if (rick) {
      rick = false; clearBody(); mode = "shell";
      if (rabbitPranked) {
        rabbitPranked = false;
        print("there was never a reward. only the journey...", "tui-out");
        print("and the song. (nothing, again. the rabbit wins.)", "tui-err");
      }
    }
    try { input.focus(); } catch (e) {}
  });

  syncWidth();
  input.focus();
})();
