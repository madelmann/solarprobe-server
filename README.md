# ☀️ SolarProbe

**SolarProbe** is a lightweight, Xymon-inspired monitoring system built around a simple idea:

> A complex server environment behaves like a solar system —  
> many independent bodies, loosely coupled, constantly in motion —  
> and small probes report back on their stability.

SolarProbe is a **push-based monitoring prototype** with a minimal server, simple clients, and a flat-file data model.  
It is designed to be **hackable, transparent, and dependency-light**, making it ideal for experimentation, scripting, and custom monitoring logic.

---

## ✨ Features

- 🌍 **Central probe server**
  - Receives status reports via plain HTTP
  - Stores state using atomic flat-file updates
  - Renders a live HTML status dashboard

- 🛰️ **Probe-based monitoring model**
  - Each monitored service is a *probe*
  - States follow the classic Xymon color model:
    - 🟢 green – OK
    - 🟡 yellow – warning
    - 🔴 red – critical
    - 🔵 blue – unknown / stale

- 🧰 **Two client implementations**
  - **Pure Bash client** – zero dependencies
  - **Slang client** – showcasing a real-world use case for the Slang language

- ♻️ **Xymon-compatible reporting**
  - Reuses existing Xymon client extensions
  - Drop-in wrapper for legacy scripts

- 📄 **Static HTML UI**
  - Overview page (all nodes × probes)
  - Per-node detail pages
  - Auto-refresh, no JavaScript required

---

## 🧠 Design Philosophy

SolarProbe intentionally avoids:

- Databases
- Message queues
- Agents with background daemons
- Heavy runtimes (Python, Java, Go, …)

Instead, it embraces:

- **Shell scripts**
- **Line-oriented protocols**
- **Append-only logs**
- **Atomic file writes**
- **Readable state on disk**

The result is a system you can fully understand by reading the source — and modify in minutes.

