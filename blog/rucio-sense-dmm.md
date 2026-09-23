---
title: "SDN for HEP Data: The Rucio-SENSE Data Movement Manager"
date: 2026-09-10
excerpt: A look at the Data Movement Manager (DMM) — the interface layer between Rucio/FTS and SENSE that lets high-energy physics transfers request software-defined network paths.
---

# SDN for HEP Data: The Rucio-SENSE Data Movement Manager

Last week I shipped the [Data Movement Manager (DMM)](https://github.com/groundsada/rucio-sense-dmm) prototype — the interface layer between **Rucio/FTS** and **SENSE** in the Rucio-SENSE interoperation framework. Here's what it does and why it matters.

## The problem

High-energy physics (HEP) experiments move petabytes of data through Rucio and FTS — but the transfers run over whatever path the IP routing happens to provide. **SENSE** (Software Defined Networking for End-to-End Services) gives those transfers a real option: dynamically orchestrated, multi-domain SDN circuits that can be requested and shaped around the data flow.

The gap was glue: Rucio knows about datasets and storage elements; FTS knows about transfer jobs; SENSE knows about circuits and scheduling. Nothing spoke both languages.

## What DMM does

DMM is that interface. It sits between Rucio/FTS and SENSE and orchestrates **network-aware data transfers**:

- Rucio triggers a transfer through the DMM patch on the Rucio server.
- DMM translates the request into a SENSE orchestration — a scheduled, end-to-end SDN path between the source and destination sites.
- FTS performs the actual data movement over the SENSE-allocated circuit.

All of it runs with real production-grade credentials: X.509 host certificates for FTS authentication, SENSE OAuth credentials (`.sense-o-auth.yaml`), and standard `dmm.cfg` / `rucio.cfg` configuration.

## Deployment

Two deployment paths: **Docker** for quick local setups, and **Helm on Kubernetes** for anything production-shaped (NRP is the recommended platform — which is where the demo rig lives). The `etc/` directory has `mksecrets.sh` to build the config secrets, and the **Sites tab** in the web UI pulls the Rucio Storage Elements (RSEs) via a "Refresh Sites" button so site topology stays in sync.

## Why I care about this

Data movement is the spine of HEP. Getting network awareness into the transfer layer isn't a nice-to-have — it's how science workflows stop leaving bandwidth on the table. DMM is still early, but it's the part of the Rucio-SENSE interop that makes "SDN-operated HEP data flows" a real sentence instead of a slide.

More details (config reference, secrets, Helm values, and the SENSE OAuth wiring) are in the [repo README](https://github.com/groundsada/rucio-sense-dmm).
