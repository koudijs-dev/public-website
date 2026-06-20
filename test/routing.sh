#!/usr/bin/env bash
#
# Black-box routing tests for the preview image (Dockerfile + nginx/default.conf).
#
# Builds the image, runs the container, and asserts the routing behaviour that
# matters for visitors:
#   - /speaking AND /speaking/ both return the real page as a direct 200
#   - no response ever leaks the container's internal :8080 in a Location header
#   - unknown paths return Hugo's styled 404
#
# Usage:
#   test/routing.sh                     # build image from repo, test, clean up
#   IMAGE=ghcr.io/foo/bar:tag test/routing.sh   # test an already-built image
#   PORT=18099 test/routing.sh          # override the host port
#
set -euo pipefail
cd "$(dirname "$0")/.."

PORT="${PORT:-18088}"
CONTAINER="preview-routing-test-$$"
IMAGE="${IMAGE:-}"
BUILT_IMAGE=""

cleanup() {
    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
    [ -n "$BUILT_IMAGE" ] && docker rmi "$BUILT_IMAGE" >/dev/null 2>&1 || true
}
trap cleanup EXIT

# The image bundles ./public, so the Hugo output must exist. CI builds it before
# calling this script; locally we build it if hugo is available.
if [ ! -f public/speaking/index.html ]; then
    if command -v hugo >/dev/null 2>&1; then
        echo "==> building site (hugo --minify --baseURL /)"
        hugo --quiet --minify --baseURL "/"
    else
        echo "ERROR: public/ is not built and hugo is not installed" >&2
        exit 1
    fi
fi

if [ -z "$IMAGE" ]; then
    BUILT_IMAGE="preview-routing-test:$$"
    IMAGE="$BUILT_IMAGE"
    echo "==> docker build -> $IMAGE"
    docker build -q -t "$IMAGE" . >/dev/null
fi

echo "==> running $IMAGE on :$PORT"
docker run -d --name "$CONTAINER" -p "$PORT:8080" "$IMAGE" >/dev/null

base="http://localhost:$PORT"

# Wait for the server to accept connections.
ready=""
for _ in $(seq 1 30); do
    if curl -fsS -o /dev/null "$base/" 2>/dev/null; then ready=1; break; fi
    sleep 0.5
done
[ -n "$ready" ] || { echo "ERROR: server did not become ready" >&2; exit 1; }

fail=0
pass() { printf '  ok   %s\n' "$1"; }
bad()  { printf '  FAIL %s\n' "$1"; fail=1; }

# assert_status PATH EXPECTED_CODE
assert_status() {
    local got
    got=$(curl -s -o /dev/null -w '%{http_code}' "$base$1")
    [ "$got" = "$2" ] && pass "$1 -> $got" || bad "$1 -> $got (want $2)"
}

# assert_served_directly PATH : 2xx with no Location header (no redirect at all)
assert_served_directly() {
    local headers code loc
    headers=$(curl -s -D - -o /dev/null "$base$1")
    code=$(printf '%s' "$headers" | awk 'NR==1{print $2}')
    loc=$(printf '%s' "$headers" | grep -i '^location:' || true)
    if [ "${code:0:1}" = "2" ] && [ -z "$loc" ]; then
        pass "$1 served directly ($code, no redirect)"
    else
        bad "$1 expected direct 2xx, got code=$code location='$loc'"
    fi
}

# assert_no_port_leak PATH : no Location header points at :8080 or an absolute http origin
assert_no_port_leak() {
    local headers
    headers=$(curl -s -D - -o /dev/null "$base$1")
    if printf '%s' "$headers" | grep -iqE '^location:.*(:8080|http://)'; then
        bad "$1 leaks internal origin in Location header"
    else
        pass "$1 no :8080 leak"
    fi
}

# assert_body_contains PATH NEEDLE
assert_body_contains() {
    if curl -s "$base$1" | grep -qF "$2"; then
        pass "$1 body contains '$2'"
    else
        bad "$1 body missing '$2'"
    fi
}

echo "== status codes =="
assert_status "/"                                 200
assert_status "/speaking"                         200
assert_status "/speaking/"                        200
assert_status "/training"                         200
assert_status "/training/"                        200
assert_status "/about"                            200
assert_status "/about/"                           200
assert_status "/this-page-does-not-exist-xyz123"  404

echo "== no redirect, no :8080 leak =="
assert_served_directly "/speaking"
assert_served_directly "/training"
assert_no_port_leak    "/speaking"
assert_no_port_leak    "/training"

echo "== real page, not an error (decent answer) =="
assert_body_contains "/speaking"  "<title>Speaking | koudijs.dev</title>"
assert_body_contains "/speaking/" "<title>Speaking | koudijs.dev</title>"

echo
if [ "$fail" -ne 0 ]; then
    echo "ROUTING TESTS FAILED" >&2
    exit 1
fi
echo "ALL ROUTING TESTS PASSED"
