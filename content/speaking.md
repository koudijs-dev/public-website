---
title: "Speaking"
weight: 10
---

I'm a programmer who got curious about infrastructure, and an infrastructure person who never stopped thinking like a programmer. Ignoring the line between "software" and "ops" is where my best ideas come from.

I believe in working in the open. Everything is a file, and the more I work with AI, the more that turns out to be a surprisingly strong foundation to build on. Git fits naturally into that: history is preserved, anything can be diffed, anyone can look. That same thinking carries into how I present. My slides are [written in code](/posts/slides-as-code/), version-controlled and publicly available, with the source linked for each talk below.

<img src="/images/simon-2025.webp" style="display: block; margin: 1.5rem auto; width: 250px; border-radius: 8px;">

# Talks

My public speaking profile is on [Sessionize](https://sessionize.com/simonkoudijs/).

### Reverse GitOps - KubeCon Co-located Event *(March 2026)*

[KubeCon EU 2026 co-located session](https://colocatedeventseu2026.sched.com/event/2DY82) · [Slides](https://github.com/reverse-gitops/talks)

GitOps is well understood in one direction: desired state in Git, applied to a cluster. But what happens when you need it to work in reverse? When the cluster (or an operator) needs to write state *back* to Git? I introduced the concept of **Reverse GitOps** and walked through why it matters, where the current tooling falls short, and what a proper implementation looks like.

Recording not (yet!) available.

### Bringing Pull Requests to Life with GitOps - dotned Saturday *(May 2023)*

[Session details](https://sessionize.com/s/simonkoudijs/bringing-pull-requests-to-life-with-gitops/70756) · [Slides](https://github.com/sunib/dotned-saturday-23)

How do you give a small team the deployment confidence of a much larger one? This talk showed how GitOps and ArgoCD let a 25-person company spin up a full temporary environment for every pull request, running integration tests against it automatically, deploying to production on success, and discarding the environment when done. Live demo included.

# Podcast

### The Power of GitOps, MongoDB Atlas en Kubernetes *(Dutch)*

[k8spodcast.nl - Aflevering 65](https://www.k8spodcast.nl/afleveringen/aflevering-65-de-kracht-van-gitops-mongodb-atlas-en-kubernetes)

A deep dive into using GitOps to drive the full lifecycle of MongoDB Atlas instances from Kubernetes: creation and deletion. We explored why this pattern is surprisingly powerful and how I managed to accidentally throw away a production database.

# Training

I teach Kubernetes professionally through [ICT Improve](https://ict-improve.nl/training/delivering-modern-cloud-native-software-en), helping engineers go from zero to production-ready with modern cloud-native software delivery.

# What I'm Working On

I'm actively developing **Reverse GitOps** as a formal concept, with a manifesto at [reversegitops.dev](https://reversegitops.dev) and an open-source working prototype at [ConfigButler/gitops-reverser](https://github.com/ConfigButler/gitops-reverser).