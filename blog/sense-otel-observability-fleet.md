---
title: "One Telemetry Endpoint for a Multi-Site Fleet: sense-otel in Production"
date: 2026-09-05
excerpt: The sense-otel OTLP gateway gives every SENSE site a single push endpoint for traces, logs, and metrics — and derives site identity from credentials, never from payloads.
---

# One Telemetry Endpoint for a Multi-Site Fleet: sense-otel in Production

Running SENSE infrastructure means operating a fleet of SiteRM frontends across a lot of sites — 29 of them in the demo fleet, with 27 known issuers and 20 enrolled so far. Telemetry from all of them has to land somewhere usable without every site hardcoding our backend topology. That's what [sense-otel](https://github.com/groundsada/sense-otel) does.

## The architecture

`sense-otel` is an **OTLP gateway plus LGTM backends** in the `sense-viz` namespace. Every SiteRM frontend pushes **traces, logs, and metrics** to **one endpoint** — the gateway — which then fans out to Tempo (traces), Loki (logs), and Mimir (metrics), all in the `sense-viz` namespace. One push channel in, three backends out:

- SiteRM frontends (29 sites in the demo fleet) → OTLP push → otlp-gateway (authenticates and stamps identity) → Tempo / Loki / Mimir
- Metrics also continue to the autogole Prometheus and Grafana via pull (unchanged, still primary)

Sites never address Tempo, Loki, or Mimir directly. Backends can be moved, scaled, or replaced **without reconfiguring a single site** — that's the property the whole design is optimized for.

## The one property that matters

**Site identity comes from the credential, never from the payload.**

There is no separate identity provider to run. Every SiteRM frontend is already an OIDC issuer: it publishes `/.well-known/openid-configuration` and `/.well-known/jwks.json`, and mints short-lived RS256 tokens from an X.509 challenge-response against the host certificate. The gateway trusts them all because the collector's `oidc` extension takes `providers` as a list — so a **new site self-enrolls** by being added to `sites/registry.yaml`, and the fleet roster stays the source of truth. 20 of 27 known sites are enrolled today.

## Public endpoints

- OTLP ingest: `https://sense-otlp.nrp-nautilus.io/v1/{traces,metrics,logs}`
- In-cluster gRPC: `otlp-gateway.sense-viz.svc:4317`
- Grafana: `https://sense-viz.nrp-nautilus.io`
- Issuer registry: `sites/registry.yaml`

## Why this pattern generalizes

It's the same lesson as any fleet with a mutable topology: **centralize the trust boundary** (one gateway, credential-derived identity), **keep the fan-out internal**, and your telemetry layer becomes something you can operate rather than something that drags 29 configs behind it. If you're running multi-site observability, this is a pattern worth stealing.
