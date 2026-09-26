---
title: "Collecting network packet data on the National Research Platform"
date: 2026-06-30
excerpt: A minimal sFlow collector for Kubernetes: listen on UDP/6343 behind a ClusterIP service, decode samples to JSON or PCAP, and get real packet data off the wire at platform scale.
---
# Collecting network packet data on the National Research Platform

If you run a shared research platform, at some point you need to know what's actually on the wire. Flow counters tell you how much traffic moved between where and where. They don't tell you what the packets look like. For that you need samples: packet headers, at aggregate scale, without trying to capture every byte.

[nrp-header-collection](https://github.com/groundsada/nrp-header-collection) is how I do this on the National Research Platform. It's a small sFlow collector for Kubernetes, and I want to walk through what it actually does.

## How it works

sFlow is the sampling protocol for this. Routers and switches export sampled packet headers as UDP datagrams, usually to port 6343, and the collector's job is to listen, decode, and store. Everything runs in one pod behind a ClusterIP Service:

1. Apply the manifest: `kubectl -n <namespace> apply -f k8s/collector.yaml`
2. Grab the service's ClusterIP: `kubectl -n <namespace> get svc sflow-collector -o jsonpath='{.spec.clusterIP}'`
3. Hand that `<ClusterIP>:6343/UDP` to your cluster administrator and ask them to forward sFlow to it.

That last step is the part people forget. sFlow export is a data plane operation, typically on the switch or on the node's NIC, and the collector doesn't push. You configure the forward, the collector receives.

Decoding happens through `sflowtool`, which runs in two modes:

- `-J` dumps samples as **JSON**, easy to pipe into a query engine
- `-t` rewrites them as **PCAP**, which opens in Wireshark for a closer look

Both are available in the deployment, and the logs show decoded samples as they arrive.

## The part I like

There's a notebook in the repo, `sflow-collector.ipynb`, that walks the whole thing: deploy, **self-test with a synthetic packet**, and hand off the collector address.

The self-test matters. It sends a fake sFlow datagram to the service and confirms the whole path works, so when you hand the address to your admin you're not asking them to debug your deployment.

## Why packet samples, not just counters

Counters answer "how much". Samples answer "what kind": TCP vs UDP, packet sizes, header patterns that correlate with workflow behavior, anomalies that only show up if you look at packets.

On a shared platform, that's often the difference between "traffic looks fine" and "our MPI traffic has a giant MTU mismatch only on the east coast segment."

It's a small tool. But it's the difference between guessing about the network and measuring it, and on the NRP I'd rather measure. The [repo](https://github.com/groundsada/nrp-header-collection) has the manifest, the notebook, and the one-paragraph README that tells you everything else.
