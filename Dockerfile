# Serves the Hugo output for per-PR PREVIEW environments only.
# Production still ships via gh-pages (publish-stuff.yml) — this image is not used there.
# The build step (preview-image.yml) runs `hugo` before `docker build`, producing ./public.
FROM nginxinc/nginx-unprivileged:alpine
COPY public/ /usr/share/nginx/html/
EXPOSE 8080
