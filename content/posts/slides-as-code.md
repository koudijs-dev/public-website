---
title: "Why I build my slides in code"
date: 2026-04-01T00:00:00+01:00
draft: false
tags: ["git", "speaking", "slidev", "reveal.js"]
---

I don't use PowerPoint. Not because I think it's bad, but because I kept feeling like I was fighting the tool rather than thinking about what I wanted to say.

Git is the closest thing I have to a personal philosophy. Everything is a file. History is preserved. Anyone can look. I use it for code, for infrastructure, for documentation. It felt odd to then go build a presentation in a binary format that nobody can diff, review, or fork.

So I stopped.

## Slides are just files

When I use [Slidev](https://sli.dev) or [reveal.js](https://revealjs.com), a presentation is a markdown file with some configuration around it. I write it in my editor, version it in Git, and publish it as a website. Anyone can clone it and run it locally.

That changes how I think about talks. The presentation doesn't disappear after the event. It's just sitting there on GitHub, ready to be read or improved.

## It also fits how I think

I like combining things from different worlds. I'm a programmer who spends a lot of time thinking about infrastructure. The interesting ideas usually live where those two overlap.

Building slides in code is a small version of that. You take something creative and apply the habits from software development: version control, open source, composability. Not a big insight, but consistent with how I try to work everywhere else.

## What it unlocks

Because your slides are just a web app, you can do things that PowerPoint simply can't. For my Reverse GitOps talk at KubeCon I built the live demo straight into the slide deck. The slides talked to the Kubernetes API live on stage. The audience scanned a QR code and their input appeared on screen in real time. No switching between windows, no "let me open the terminal real quick." Everything in one place.

That part was genuinely cool and I don't think I could have pulled it off the same way with a traditional tool.

## The practical side, and the dangerous part

It's not always smooth. Slidev has opinions about layout that you sometimes have to work around. And exporting to PDF used to be fiddly, though `slidev export` has gotten good.

The bigger danger is that it's a very nice way to procrastinate. You can spend a whole evening tweaking the theme, wiring up a live API call, or getting the animations just right. And then realize you haven't actually written the talk yet.

The live demo also needs to run like clockwork. A lot of fiddling goes into making something look effortless on stage.

But the tradeoff is worth it. And honestly, writing slides in markdown keeps me honest. If I can't express an idea clearly in text, I probably don't understand it well enough yet.

You can find the source for my talks at [github.com/sunib/dotned-saturday-23](https://github.com/sunib/dotned-saturday-23) and [github.com/reverse-gitops/talks](https://github.com/reverse-gitops/talks).
