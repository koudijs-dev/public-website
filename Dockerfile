# Serves the Hugo output for per-PR PREVIEW environments only.
# Production still ships via gh-pages (publish-stuff.yml) — this image is not used there.
# The build step (preview-image.yml) runs `hugo` before `docker build`, producing ./public.
FROM nginxinc/nginx-unprivileged:alpine
# Keep redirects relative so the container's internal :8080 doesn't leak into
# Location headers when served behind the preview reverse proxy (see the file).
COPY nginx/relative-redirect.conf /etc/nginx/conf.d/00-relative-redirect.conf
COPY public/ /usr/share/nginx/html/
EXPOSE 8080
