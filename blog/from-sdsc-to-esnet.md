---
title: "Leaving San Diego for Berkeley: my move from SDSC to ESnet"
date: 2026-09-01
excerpt: After years building shared infrastructure at SDSC — the NRP, SEAM, P4 on FPGAs — I joined ESnet to work on the data movement problem itself.
---

# Leaving San Diego for Berkeley: my move from SDSC to ESnet

September 2026 was a big month: I packed up a decade's worth of habits (and a very specific P4 toolchain) and moved from San Diego to the Bay Area to join **ESnet** at Lawrence Berkeley National Laboratory as a research networking systems engineer.

## The San Diego years

SDSC gave me everything, honestly. I came in working on the **National Research Platform** — that sprawling, multi-tenant Kubernetes environment that lets researchers at campuses all over the country run science jobs with just a notebook and a shadow account. My corner of it: the Kubernetes substrate itself (stretching a k8s cluster across states, keeping multi-tenancy sane), FABRIC integration so NRP and the testbed world could talk to each other, and the SENSE work that turned network services into something operators can automate.

I also led the **SEAM** project (Kubernetes-aware programmable networking and cloud provisioning) and did the thing I still love most: **P4 on FPGAs** — including a PEARC '25 paper on real-time in-network machine learning on SmartNICs, where we got ML classifiers into the packet path with fixed-point arithmetic and Taylor approximations instead of floating point. It works, and it's fast, and I'll be explaining that to people for years.

And somewhere in there I became a teacher: SDSC's on-demand learning courses, *Introduction to the National Research Platform* and *Intermediate Kubernetes*. Teaching that material changed how I think about every piece of infrastructure I touch.

## Why I moved

Because I kept teaming down: I'd build beautiful shared infrastructure, but the *science* — the data — was always someone else's problem. High-energy physics moves tens of petabytes; the network is the part that decides whether a transfer finishes tonight or next week. **I wanted to work on the data movement problem itself.**

At ESnet, that's exactly the job. SENSE software-defined networking for science, Rucio/FTS interoperability for HEP, and the unglamorous-but-vital art of making transfers scheduleable, observable, and fast. It's the same community — the NRP, the SENSE family, the DOE world — but I'm now on the side that carries the data.

## The part nobody mentions

Leaving was still hard. You accumulate borrowings in a place: the people, the workflows, the exact incantation to spin up a GPU node at 11 p.m. And moving to a new lab means proving the "new guy" part of yourself a little bit again.

But the work excites me in a way I haven't felt since I first saw a P4 pipeline compile. That's worth a cross-state move. Onward.
