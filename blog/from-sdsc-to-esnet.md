---
title: "From SDSC to ESnet: changing the problem I work on"
date: 2026-09-01
excerpt: I spent years in San Diego building shared infrastructure. In September 2026 I moved to ESnet to work on the data movement problem itself.
---

# From SDSC to ESnet: changing the problem I work on

September 2026 was a busy month. I moved from San Diego to the Bay Area to join ESnet at Lawrence Berkeley National Laboratory as a research networking systems engineer.

The San Diego years were good. I came in working on the National Research Platform, that multi-tenant Kubernetes environment where researchers at campuses all over the country run science jobs from a browser tab. My corner of it was the Kubernetes substrate itself, stretching a cluster across states, keeping multi-tenancy from collapsing under its own weight, and wiring NRP into FABRIC so the two worlds could talk. I led the SEAM project, built the SENSE Kubernetes operator, and did the work I'm still fondest of: P4 on FPGAs, including a paper on real-time machine learning inside the packet path on SmartNICs. Fixed-point arithmetic and Taylor approximations got us classifiers onto the wire at line rate, which is a sentence I never expected to write when I started.

Somewhere in there I also started teaching. SDSC's on-demand courses, Introduction to the National Research Platform and Intermediate Kubernetes. Teaching that material changed how I think about infrastructure. It's hard to hand-wave a subsystem when someone is asking which knob to turn.

I left because I was tired of being one layer removed from the science. I'd build shared infrastructure, and the data that justified it was always somebody else's problem. High-energy physics moves tens of petabytes. The network decides whether a transfer finishes tonight or next week. That's the problem I actually wanted to work on.

At ESnet that's the job. SENSE software-defined networking for science, Rucio and FTS interop for HEP, and the less glamorous work of making transfers something you can schedule, observe, and speed up.

Moving was still hard. You accumulate debts in a place: the people, the workflows, the exact incantation to get a GPU node at 11 p.m. And joining a new lab means being the new guy again.

The work excites me in a way I haven't felt in a while. That's worth the move.
