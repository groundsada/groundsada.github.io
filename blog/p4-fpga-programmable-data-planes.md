---
title: "P4 on FPGAs and SmartNICs: What Programmable Data Planes Taught Me"
date: 2025-10-25
excerpt: From P4 on Xilinx FPGAs to SmartNIC testbeds and sFlow tooling — a retrospective on why the data plane is the most interesting place in networking to be.
---

# P4 on FPGAs and SmartNICs: What Programmable Data Planes Taught Me

Before I moved into research networking systems, I spent my time as close to the packets as you can get on commodity hardware — programmable data planes. This is a short retrospective on that work, collected in one place.

## P4 on Xilinx FPGAs

The [P4-on-Xilinx-FPGAs](https://github.com/groundsada/P4-on-Xilinx-FPGAs) project was about running P4 programs on Xilinx FPGAs — the toolchain pain most people don't talk about: Vivado for the hardware side, P4 development tools on the language side, and a lot of glue to make the two agree. It taught me that the interesting constraints in packet processing are never where you expect: memory bandwidth, table sizes, and pipeline stages dominate, not raw clock speed.

## SmartNIC testbeds and SRv6

Around the same time I was working on the ESnet SmartNIC line of work — hardware bring-up on SN1022-based NICs, the [esnet-smartnic-hw-sn1022](https://github.com/groundsada/esnet-smartnic-hw-sn1022) board support layer, a tutorial repo for getting started, and a bitfile builder for reproducible builds. On the protocol side, the SPRITE-SRv6-FPGA work combined segment routing (SRv6) with FPGA-offloaded processing — my first real taste of "the network is programmable, not just configurable."

## Observing the data plane

You can't optimize what you can't see, which is why I also build the tooling around the plane: [sflowtool](https://github.com/groundsada/sflowtool) for decoding binary sFlow feeds, plus P4Kube-adjacent experiments for running programmable data planes next to Kubernetes workloads. The same principle carries into my current work — instrument first, then you can reason about what the network is actually doing.

## What stuck with me

Three lessons carried forward into everything since:

- **The data plane is a resource budget.** Every table, every pipeline stage, every SRAM byte is a trade-off. Systems who know this can build networks that do real work at line rate.
- **Repeatable builds are infrastructure.** A bitfile builder, a versioned toolchain, a testbed — the boring parts are what let you actually experiment.
- **Programmability is a spectrum.** From FPGA-specific P4 targets to SmartNIC offload to software switches, the right answer depends on what you're willing to pay in development time vs. what you get in flexibility.

The repos are public if you want to poke around: [P4-on-Xilinx-FPGAs](https://github.com/groundsada/P4-on-Xilinx-FPGAs), [esnet-smartnic-hw-sn1022](https://github.com/groundsada/esnet-smartnic-hw-sn1022), [sflowtool](https://github.com/groundsada/sflowtool).
