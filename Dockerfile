# Serves the Hugo output for per-PR PREVIEW environments only.
# Production still ships via gh-pages (publish-stuff.yml) — this image is not used there.
# The build step (preview-image.yml) runs `hugo` before `docker build`, producing ./public.
FROM nginxinc/nginx-unprivileged:alpine
# Serve Hugo's pretty URLs for both /path and /path/ as a direct 200 (no
# redirect), so the container's internal :8080 never leaks into a Location
# header behind the preview reverse proxy. See nginx/default.conf.
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
EXPOSE 8080
