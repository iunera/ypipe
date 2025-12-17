#!/bin/sh

set -eu

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() { printf "%b\n" "${GREEN}$*${NC}"; }
info() { printf "%b\n" "$*"; }
err() { printf "%b\n" "${RED}$*${NC}" 1>&2; }
die() { err "$*"; exit 1; }

# Determine project directory (directory of this script)
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
cd "$SCRIPT_DIR"

usage() {
  cat <<USAGE
Usage: $(basename "$0") start|stop

Commands:
  start   Start Data Philter stack with configured backends
  stop    Stop all Data Philter services (all profiles)

This script reads configuration from app.env and sets COMPOSE_PROFILES accordingly.
USAGE
}

# Browser opener and readiness wait (borrowed from install.sh)
open_browser() {
    URL=$1

    WAIT_TIMEOUT=120
    WAIT_INTERVAL=2
    waited=0

    info "Waiting for backend to become available at $URL (timeout: ${WAIT_TIMEOUT}s)..."
    while [ $waited -lt $WAIT_TIMEOUT ]; do
        if command -v curl >/dev/null 2>&1; then
            if curl -fsS -o /dev/null "$URL/actuator/health" >/dev/null 2>&1; then
                log "Backend is up!"
                break
            fi
        elif command -v wget >/dev/null 2>&1; then
            if wget -q --spider "$URL" >/dev/null 2>&1; then
                log "Backend is up!"
                break
            fi
        else
            if [ $waited -eq 0 ]; then
                info "curl/wget not found — waiting 10s before opening the browser..."
            fi
            sleep 10 || true
            waited=$((waited + 10))
            break
        fi
        sleep $WAIT_INTERVAL || true
        waited=$((waited + WAIT_INTERVAL))
    done

    if [ $waited -ge $WAIT_TIMEOUT ]; then
        err "Backend did not become ready within ${WAIT_TIMEOUT}s. You may need to wait a bit longer."
    fi

    OS=$(uname -s)
    case "$OS" in
        Linux)
            if command -v xdg-open >/dev/null 2>&1; then
                xdg-open "$URL" >/dev/null 2>&1 &
                log "Opening $URL in your default browser..."
            else
                info "Could not find xdg-open. Please open $URL manually."
            fi
            ;;
        Darwin)
            open "$URL" >/dev/null 2>&1 &
            log "Opening $URL in your default browser..."
            ;;
        *)
            info "Unsupported OS for automatic browser opening. Please open $URL manually."
            ;;
    esac
}

# Load app.env if present to get PHILTER_BACKENDS (export variables)
if [ -f "app.env" ]; then
  # shellcheck disable=SC2046
  set -a && . ./app.env && set +a || true
fi

# Map PHILTER_BACKENDS -> COMPOSE_PROFILES
# Accepted values (case-insensitive): none, druid, clickhouse, all, druid,clickhouse
to_lower() { printf "%s" "$1" | tr '[:upper:]' '[:lower:]'; }

BACKENDS=$(to_lower "${PHILTER_BACKENDS:-}")
case "$BACKENDS" in
  ""|none)
    PROFILES=""
    ;;
  all|"druid,clickhouse"|"clickhouse,druid")
    PROFILES="druid,clickhouse"
    ;;
  druid)
    PROFILES="druid"
    ;;
  clickhouse)
    PROFILES="clickhouse"
    ;;
  *)
    err "Unknown PHILTER_BACKENDS value: '$PHILTER_BACKENDS'. Expected one of: none, druid, clickhouse, all."
    PROFILES=""
    ;;
esac

CMD=${1:-}
case "$CMD" in
  start)
    if [ -n "$PROFILES" ]; then
      log "Starting Data Philter with profiles: $PROFILES"
      COMPOSE_PROFILES="$PROFILES" docker compose up -d
    else
      log "Starting Data Philter without optional backends"
      docker compose up -d
    fi
    open_browser "http://localhost:${SERVER_PORT:-4000}"
    ;;
  stop)
    log "Stopping all Data Philter services (all profiles)"
    COMPOSE_PROFILES="*" docker compose down
    ;;
  -h|--help|help|*)
    usage
    [ "$CMD" = "start" ] || [ "$CMD" = "stop" ] || exit 2
    ;;
esac
