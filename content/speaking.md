---
title: "Speaking"
weight: 10
---

I'm a programmer who got curious about infrastructure, and an infrastructure person who never stopped thinking like a programmer. Ignoring the line between "software" and "ops" is where my best ideas come from.

I believe in working in the open. Everything is a file, and the more I work with AI, the more that turns out to be a surprisingly strong foundation to build on. Git fits naturally into that: history is preserved, anything can be diffed, anyone can look. That same thinking carries into how I present. My slides are [written in code](/posts/slides-as-code/), version-controlled and publicly available, with the source linked for each talk below.

<img src="/images/simon-2025.webp" style="display: block; margin: 1.5rem auto; width: 250px; border-radius: 8px;">

# Talks

My public speaking profile is on [Sessionize](https://sessionize.com/simonkoudijs/).

## Upcoming

### Be BFFs with the Kubernetes API - Frontmania 2026 *(7 October 2026)*

[Frontmania 2026](https://frontmania.com/) · Jaarbeurs, Utrecht 🇳🇱

Kubernetes is famous for running containers, but its API model is the interesting part: flexible resources, desired state, live updates through watches, validation, and advanced access control. Platform engineers use these ideas every day. Frontenders usually only get the boring REST endpoint at the end. Isn't that a missed opportunity?

I've built an open-source coffee-ordering demo where the whole audience gets admin rights: grab your phone and configure my demo, and let's see how live updates are not only cool but also useful for handling conflicts. This is not a talk about exposing your production infrastructure to the public internet. It is about running a small, dedicated Kubernetes API server as a product backend. Kubernetes may not become your best friend forever, but could it become your Backend for Frontend?

### We GitOps'd Everything Except the Settings That Break Production - Dutch Cloud Native Day 2026 *(30 October 2026)*

[Dutch Cloud Native Day 2026](https://www.dutchcloudnativeday.nl/) · Jaarbeurs, Utrecht 🇳🇱

Software teams have a delivery process for code. But what about the runtime configuration around that code? It is often self-service for end users, hidden behind admin screens and custom database tables, and changed outside the delivery process. Feature flags, business rules, and specific domain settings can change production behaviour just as much as new code.

This talk starts with application settings that broke production. Each one led to the same uncomfortable questions: who made the change, where was it validated, and how do we stop the next one? Could important product configuration live in a separate Git repo, reviewed and promoted like code, while the people who change it never see Git and just use a nice settings screen? I'll show the design of the open-source tool I built to explore this and where it gets hard (conflicts, concurrency, and putting real authors on Git commits), then demo it live with the whole audience as admins.

### Configuration Deserves a Software Delivery Process Too - Øredev 2026 *(5 November 2026)*

[Øredev 2026 speaker page](https://oredev.org/program/da064424-8d62-40e7-bdf9-c0f082f422e9) · Malmö 🇸🇪

Configuration is often some of the most critical logic in a system, yet many teams manage it with far less discipline than code. It lives in databases, gets edited through admin screens, bypasses review, mixes awkwardly with secrets, and moves across environments with weak packaging boundaries. This talk argues configuration should be treated as a delivery problem, not just a storage problem: capture validated intent through an API, then turn it into configuration that is tested, packaged, versioned, signed, and promoted through environments as controlled artifacts.

### (Ab)using the Kubernetes API as a Configuration Backend - Øredev 2026 *(6 November 2026)*

[Øredev 2026 speaker page](https://oredev.org/program/da064424-8d62-40e7-bdf9-c0f082f422e9) · Malmö 🇸🇪

Configuration-heavy products keep reinventing the same backend machinery: typed objects, validation, permissions, audit trails, and some form of realtime change propagation. Over time, that configuration backend starts to look a lot like a control plane. This talk explores the Kubernetes API as a backend for configuration-heavy software products rather than as an infrastructure surface, including what the approach enables, which trade-offs it introduces, and where the model starts to break down.

### What If All Configuration Could Have a Kubernetes-Style API? - DDC 2026 *(26 November 2026)*

[DDC 2026 programme](https://www.developer-world.com/ddc-programm) · Half-day workshop · Hyatt Regency, Cologne 🇩🇪

The best REST API I have ever seen is Kubernetes, not because it runs containers, but because the API machinery underneath it is flexible enough to model many kinds of intent: typed resources, schema validation, optimistic concurrency, watches, status, events, audit, authentication, and resource-level authorization. Pods and deployments are just the famous examples.

Application configuration is our practical case. We inspect a configurable coffee-ordering app and improve its model together, deciding how to split settings across one or more resource types, how to model the one-to-many relationships, how to define authorization, and the harder question of what happens to existing values when the model itself changes. You get hands-on in your own devcontainer, working at two levels: first changing the configuration, then changing the definition itself. Feeling the difference between changing config and evolving its schema is the core of the workshop. You do not need to be a Kubernetes operator, or even plan to use Kubernetes.

## Given

### GitOps Needs an API - Swiss Cloud Native Day 2026 *(17 September 2026)*

[Session details](https://cloudnativeday.ch/sessions/1223005) · Mount Gurten, Bern 🇨🇭 · Slides: [PDF](https://github.com/reverse-gitops/talks/blob/main/dist/gitops-needs-an-api.pdf), [Repo](https://github.com/reverse-gitops/talks)

GitOps works well. Well enough that high-level business intent ends up in Git too: customer tenants, feature rollouts, access policies. The hard part is not storing it there. The hard part is expecting business stakeholders or customers to manage it through pull requests and raw YAML.

Reverse GitOps is an API-first pattern for exactly this problem. A typed Kubernetes API in front of your repo accepts structured intent through CRDs, without giving callers direct access to Git. A controller turns that intent into YAML files and commits them to Git. From there you keep the GitOps workflow you already trust: review, policy checks, CI, and a full audit trail.

I demoed this live using the open-source [`gitops-reverser`](https://github.com/ConfigButler/gitops-reverser) operator, and closed with an honest checklist: where this pattern shines (low-churn, high-impact configuration that needs review and audit), and where it is the wrong tool (high-frequency writes, tight latency requirements, or anything that belongs in a normal database).

### What If Every Cozystack Change Became a Commit? - CozySummit Virtual 2026 *(26 May 2026)*

[CozySummit event](https://community.cncf.io/events/details/cncf-virtual-project-events-hosted-by-cncf-presents-cozysummit-virtual-2026/) · Slides: [PDF](https://github.com/reverse-gitops/talks/blob/main/cozystack/slides.pdf) · [Watch on YouTube](https://www.youtube.com/watch?v=dkyjOq-I7Zs)

<div class="video-embed"><iframe src="https://www.youtube.com/embed/dkyjOq-I7Zs" title="What If Every Cozystack Change Became a Commit? — CozySummit Virtual 2026" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe></div>

Cozystack exposes platform services as Kubernetes API resources: Postgres, Redis, Bucket, Kubernetes. Users interact in the usual ways: kubectl, the Cozystack dashboard, or AI agents via MCP. But who is making all these changes, and why? Git seems far away. But it doesn't have to be. What if every platform change automatically appeared as clean YAML in Git? Fully automated, a silent layer that turns API activity into a durable, readable history of infrastructure intent. Instead of digging through logs or dashboards, teams get versioned history they can inspect, diff, and share. The platform continuously writes its intent back to Git. Git stops being the interface and starts being the memory.

### Who Tests the Configuration? - TestNet Spring Event *(6 May 2026)*

[TestNet event](https://www.testnet.org/evenement/entry/29924/?evenement=voorjaarsevenement-2026) *(Dutch)*

Much of what impacts production isn't code but configuration: business rules, feature flags, content, rate limits, deployment settings, database connection details. Because configuration is so broad and scattered, it's often unclear what falls under it, who can change it, and how to properly test those changes. This session shows why that's a quality problem and how to make configuration changes visible, reviewable, and testable before production, using pull requests to spin up temporary environments for impact testing.

### Reverse GitOps - KubeCon Co-located Event *(23 March 2026)*

[KubeCon EU 2026 co-located session](https://colocatedeventseu2026.sched.com/event/2DY82) · Slides: [PDF](https://raw.githubusercontent.com/reverse-gitops/talks/refs/heads/main/dist/the-gitops-paradox.pdf), [Repo](https://github.com/reverse-gitops/talks) · [Watch on YouTube](https://www.youtube.com/watch?v=X3sUAsTPbDM)

<div class="video-embed"><iframe src="https://www.youtube.com/embed/X3sUAsTPbDM" title="The GitOps Paradox — KubeCon Platform Engineering Day 2026" loading="lazy" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe></div>

GitOps is well understood in one direction: desired state in Git, applied to a cluster. But what happens when you need it to work in reverse? When the cluster (or an operator) needs to write state *back* to Git? I introduced the concept of **Reverse GitOps** and walked through why it matters, where the current tooling falls short, and what a proper implementation looks like.

![Platform Engineering Day EU 2026 Speaker](/images/platform-engineering-day-eu-2026-speaker-badge.png)

### Bringing Pull Requests to Life with GitOps - dotned Saturday *(May 2023)*

[Session details](https://sessionize.com/s/simonkoudijs/bringing-pull-requests-to-life-with-gitops/70756) · [Slides](https://github.com/sunib/dotned-saturday-23)

How do you give a small team the deployment confidence of a much larger one? This talk showed how GitOps and ArgoCD let a 25-person company spin up a full temporary environment for every pull request, running integration tests against it automatically, deploying to production on success, and discarding the environment when done. Live demo included.

# Podcast

### The Power of GitOps, MongoDB Atlas en Kubernetes *(Dutch)*

[k8spodcast.nl - Aflevering 65](https://www.k8spodcast.nl/afleveringen/aflevering-65-de-kracht-van-gitops-mongodb-atlas-en-kubernetes)

A deep dive into using GitOps to drive the full lifecycle of MongoDB Atlas instances from Kubernetes: creation and deletion. We explored why this pattern is surprisingly powerful and how I managed to accidentally throw away a production database.

# Training

I teach Kubernetes professionally through [ICT Improve](https://ict-improve.nl/).

I teach these courses:
* [Delivering Modern Cloud-Native Software](https://ict-improve.nl/training/delivering-modern-cloud-native-software-en): understand better how Kubernetes exactly can deploy your workloads into production
* [Applied AI for Test Automation with Playwright](https://ict-improve.nl/training/applied-ai-for-test-automation-with-playwright-en): using AI to write and maintain browser tests

# What I'm Working On

Apart from my consultancy/trainer work, I've also been working on Reverse GitOps: an idea that actors deserve an API to indicate their intent, while Git remains the source of record. There's a write-up at [reversegitops.dev](https://reversegitops.dev) and an open-source prototype at [ConfigButler/gitops-reverser](https://github.com/ConfigButler/gitops-reverser).
