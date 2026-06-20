# refactor.md — build a preview container image on every branch

Scope: **this repo only** (`koudijs-dev/public-website`). The goal is to publish a
container image of the site on **every push to every branch**, so an external GitOps system
can spin up a per-PR preview. That's the whole job for this repo — it doesn't need to know
anything about Kubernetes.

## What does NOT change

- ❌ `publish-stuff.yml`, the `gh-pages` branch, GitHub Pages, and `koudijs.dev` —
  **production is untouched.** Keep shipping exactly as today.
- ❌ `config.yml` and its `baseURL: https://koudijs.dev/` — left as-is (production needs it).

## What to add (2 files + 1 one-time setting)

### 1. `Dockerfile`

`public/` is gitignored, so CI builds the site first (next step) and this image just serves
the result from the same unprivileged nginx the workshop apps use (listens on **8080**):

```dockerfile
# Serves the Hugo output for per-PR PREVIEW environments only.
# Production still ships via gh-pages (publish-stuff.yml) — this image is not used there.
# The build step (preview-image.yml) runs `hugo` before `docker build`, producing ./public.
FROM nginxinc/nginx-unprivileged:alpine
COPY public/ /usr/share/nginx/html/
EXPOSE 8080
```

### 2. `.github/workflows/preview-image.yml`

Runs on **every branch** (before any PR exists — so the image is ready the moment a PR
opens). Builds the site with the **same Hugo** production uses, then pushes the image to
GHCR with two tags.

```yaml
name: preview-image

on:
  push:
    branches: ['**']            # every branch, before a PR is opened
    paths-ignore:
      - 'README.md'
      - 'LICENSE'
  workflow_dispatch:

permissions:
  contents: read
  packages: write               # push to ghcr.io

env:
  IMAGE: ghcr.io/${{ github.repository }}   # -> ghcr.io/koudijs-dev/public-website

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Same Hugo as production (publish-stuff.yml): extended 0.148.1.
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.148.1'
          extended: true

      # --relativeURLs so internal links resolve on ANY preview host
      # (pr<N>.preview.koudijs.dev) without baking the per-PR hostname into the build.
      - name: Build site
        run: hugo --minify --relativeURLs --baseURL "/"

      - name: Log in to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Image tags
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.IMAGE }}
          tags: |
            type=ref,event=branch       # :<branch>     (human-friendly, moves)
            type=sha,format=short       # :sha-<short>  (immutable — what previews pin to)

      - name: Build & push
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

### 3. One-time: make the GHCR package public

After the first run publishes `ghcr.io/koudijs-dev/public-website`, set the package
visibility to **Public** (repo → Packages → the image → *Package settings* → *Change
visibility*). The preview cluster pulls anonymously; public avoids a pull secret. (If you'd
rather keep it private, say so and we'll wire a pull secret on the cluster side instead.)

## The contract the deployer relies on 🔑

The external GitOps system deploys **exactly** this, per open PR:

```
ghcr.io/koudijs-dev/public-website:sha-<short-commit-sha>
```

So the only hard requirement is: **keep the `type=sha,format=short` tag** (→ `sha-<7hex>`).
Everything else (the `:<branch>` tag, paths-ignore, etc.) is free to change. If you ever
change the image name or the SHA tag format, the preview side must change to match.

> Why pin to `sha-…` and not `:<branch>`? It's immutable — a new commit is a new tag, which
> is what makes a push to the PR actually redeploy instead of silently reusing a cached
> image.

## Verify

Locally (mimics what CI does):
```bash
hugo --minify --relativeURLs --baseURL "/"
docker build -t public-website:test .
docker run --rm -p 8080:8080 public-website:test   # open http://localhost:8080
```

In CI: push any branch, then check the run is green and the package appears:
```bash
gh run list --workflow=preview-image.yml --limit 3
# package shows up under the repo's Packages, tagged :sha-<short> and :<branch>
```

## Checklist

- [ ] `Dockerfile` added (nginx-unprivileged, copies `public/`, port 8080)
- [ ] `.github/workflows/preview-image.yml` added (builds on every branch, pushes 2 tags)
- [ ] Pushed a branch and the run is green
- [ ] `ghcr.io/koudijs-dev/public-website` package set to **Public**
- [ ] `publish-stuff.yml` / `gh-pages` / `koudijs.dev` confirmed **unchanged**
```
