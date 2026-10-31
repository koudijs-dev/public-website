# Serves the Hugo output. Two builds use it, both running `hugo` first to produce ./public:
#   preview-image.yml  -> sha-<short>, baseURL "/", for per-PR previews
#   publish-stuff.yml  -> prod-sha-<short>, the real baseURL, for koudijs.dev itself
# Pinned by digest so Dependabot proposes (and the routing test gates) base
# image bumps; the :alpine tag is kept for readability.
FROM nginxinc/nginx-unprivileged:alpine@sha256:a8d5564c3354241473c1e152d5dd3281ab4224edb61b23c291e0bfd9854687a1
# Serve Hugo's pretty URLs for both /path and /path/ as a direct 200 (no
# redirect), so the container's internal :8080 never leaks into a Location
# header behind the preview reverse proxy. See nginx/default.conf.
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/
EXPOSE 8080
