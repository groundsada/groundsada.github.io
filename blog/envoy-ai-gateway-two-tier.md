---
title: "How LLM Gateways Work: A Two-Tier Envoy Architecture for AI Services"
date: 2026-05-20
excerpt: A practical walkthrough of the two-tier Envoy AI Gateway pattern I talked about at the 7NRP workshop — centralized auth and rate limiting up front, smart model routing behind.
---

# How LLM Gateways Work: A Two-Tier Envoy Architecture for AI Services

When you're running LLM inference for a fleet of users — or a fleet of agents — you quickly discover that "point the client at the model server" doesn't scale. You need authentication, routing, rate limits, observability, and the ability to shift traffic between local models and providers. That's the job of an **LLM gateway**, and the pattern I want to describe is the one I covered in my 7NRP workshop talk: the **two-tier gateway** built on Envoy Gateway and the [Envoy AI Gateway](https://github.com/groundsada/ai-gateway) project.

## The two tiers

- **Tier One — the centralized entry point.** Handles authentication, top-level routing, and global rate limiting. Every client request hits this tier first, so policy is enforced exactly once, in one place, outside the blast radius of any single model backend.
- **Tier Two — the model serving cluster ingress.** Provides fine-grained control over self-hosted model access, including the **endpoint picker** — which chooses between replicas/instances for LLM inference optimization. This is where locality, load, and latency get mixed into routing decisions.

Requests flow straight down the tiers: clients hit the Tier One Gateway (auth, routing, global rate limiting), which forwards to the Tier Two Gateway (endpoint picker, fine-grained model access), which selects a backend in the model serving cluster.

## Why Envoy

Envoy Gateway inherits the essential attributes of Envoy: battle-tested HTTP/RPC handling, rich observability (access logs, metrics, tracing), and a pluggable filter chain that makes extension points like the endpoint picker natural. The gateway also supports a wide range of AI providers — OpenAI, Azure OpenAI, Google Gemini, Vertex AI, AWS Bedrock, and self-hosted endpoints — so one entry point can front a heterogeneous model fleet.

## Why this matters for research platforms

On a shared platform like the National Research Platform, you have many users, a handful of GPU nodes with different model loads, and providers that may or may not be reachable at any given moment. A two-tier gateway is what lets you:

- Enforce quotas and auth once, regardless of which model a request lands on.
- Route around a loaded backend via the endpoint picker instead of failing.
- **Understand your AI traffic** — per-user, per-model, per-backend — because the gateway sees everything.

Observability-first routing has been my theme through [sense-otel](/blog/sense-otel-observability-fleet) and the ai-gateway work: gateways aren't just policy — they're the best telemetry point you have. The full two-tier reference (including the deployment/reference docs and draw.io diagrams) is in the [ai-gateway repository](https://github.com/groundsada/ai-gateway).
