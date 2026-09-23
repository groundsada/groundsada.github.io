---
title: "Teaching the National Research Platform, one classroom at a time"
date: 2025-09-02
excerpt: Somewhere between debugging Kubernetes and profiling P4 pipelines, I became an instructor for SDSC's NRP courses. It turned out to be the best part of the job.
---

# Teaching the National Research Platform, one classroom at a time

The National Research Platform (NRP) is a strange and wonderful thing: a **stretched, multi-tenant Kubernetes platform** that lets researchers at campuses across the country run their science with nothing more than a browser tab. Building it is interesting. Teaching it turned out to be more interesting.

## The courses

In 2025 I became an instructor for SDSC's on-demand learning series, covering two of my favorite topics:

- **Introduction to the National Research Platform** — what the NRP is, who it's for, and how to get a first job running on shared science infrastructure
- **Intermediate Kubernetes** — the less glossy part: multi-tenancy, resource management, and the sharp edges that only show up when a hundred researchers share one platform

## Why I teach

There's the selfish reason: **you don't actually understand a system until you teach it.** Explaining how a stretched cluster schedules a job across three states forces you to admit which parts you've been hand-waving. Every course cycle, I found at least one bug in my own mental model.

And there's the real reason: shared infrastructure only works if the *people* can use it. The students I remember most are researchers from completely non-CS fields — genomics, hydrology, economics — who walked in with a dataset and a deadline, and walked out with a running job on a platform that until a few years ago didn't exist. That moment is worth all the debugging.

Growing up, I was the student grinding USACO problem sets and college CS assignments, never once imagining I'd end up teaching distributed systems. Getting to hand someone their first real compute is a genuinely nice version of "giving back."

*The NRP is a national asset. If you're at a US research institution and haven't tried it, the intro course is still free on SDSC's learning site — you should.*
