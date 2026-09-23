---
title: "Metrics for an AI card: a Prometheus exporter for Qualcomm Cloud AI 100"
date: 2026-03-25
excerpt: Twenty-plus metrics scraped from qaic-util every 15 seconds — power, temperature, NSP load, DRAM, inference load — in a tiny exporter that needs no custom image.
---

# Metrics for an AI card: a Prometheus exporter for Qualcomm Cloud AI 100

Research platforms are quietly adopting AI accelerators that are not Nvidia GPUs. One of them, the **Qualcomm Cloud AI 100**, is a genuinely interesting device: a purpose-built inference accelerator with program cores, NSPs (Neural Streaming Processors), and its own memory hierarchy. It also ships with a famous problem in shared infrastructure: **nobody knows what it's doing.**

That's where [qaic-prometheus-exporter](https://github.com/groundsada/qaic-prometheus-exporter) comes in.

## The problem

If you're running a fleet of accelerators for dozens of researchers, you need to answer boring questions quickly: Is this card idle? Is it hot? Is it actually running my network? One card running at 99% NSP utilization while another sits at 0% is a normal day, and without metrics you'd never know.

The device exposes information through `qaic-util -q`, but nothing spoke Prometheus. So I wrote the missing piece.

## What it does

Every 15 seconds, the exporter scrapes `qaic-util` and exposes **per-QID metrics** (each device exposes multiple "QIDs" — quantized inference devices) with labels for `qid`, `node`, `pci_address`, `hw_version`, `fw_version`, and `sku_type`:

- **Power & thermals** — board and SoC power draw, TDP caps, SoC temperature in Celsius
- **Memory** — DRAM total/free/used, fragmentation percentage, bandwidth; retired pages
- **Compute** — NSP availability and frequency, program cores, virtual channels, semi-channels, MCIDs
- **Inference** — loaded/active networks, constants in use
- **Health** — scrape success, duration, device status

That's **20+ metrics** per card, which turns "is the cluster of AI cards okay?" from a prayer into a dashboard.

## The design detail I like most

No custom image needed. The scraper is injected as a **ConfigMap into the official SDK image**, so upgrading the exporter doesn't mean rebuilding and re-publishing a fork of a vendor image — a small thing that makes adoption way easier for operators (and for my future self).

## Why this matters

Observability is the quiet part of AI infrastructure. A card that can be *seen* can be *scheduled* — and a research platform that can schedule underutilized accelerators is one that serves more science per dollar. Same philosophy I brought to [the SENSE observability work]... which is still under construction — this one is shipped, documented, and [live on GitHub](https://github.com/groundsada/qaic-prometheus-exporter).
