#!/usr/bin/env bash
# todo: make this a watchscript
set -euo pipefail

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/weather/location"

# ── helpers ───────────────────────────────────────────────────────────────────

die()   { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
    cat >&2 <<EOF
usage: $(basename "$0") <command>

commands:
  temperature   current temperature       (e.g. 15°)
  condition     weather description       (e.g. Cloudy)
  location      detected/configured city  (e.g. Dublin)
  set-location  <city>  write city to config file

config file: $CONFIG
  create it manually (echo "Paris" > "$CONFIG")
  or use set-location to write it from here.
  delete it to return to IP-based auto-detection.
EOF
    exit 1
}

location_param() {
    if [[ -f "$CONFIG" ]]; then
        local city
        city=$(head -n1 "$CONFIG" | tr -s '[:space:]' '+' | sed 's/^+//;s/+$//')
        printf '%s' "$city"
    else
        printf ''
    fi
}

fetch() {
    local fmt="$1"
    local loc
    loc=$(location_param)

    local url="https://wttr.in/${loc}?format=${fmt}"

    local out
    out=$(curl -sf --max-time 8 "$url") \
        || die "could not reach wttr.in — check your connection"

    [[ -n "$out" ]] || die "wttr.in returned an empty response (bad location?)"

    printf '%s\n' "$out"
}

reverse_geocode() {
    local lat="$1" lon="$2"
    local city
    city=$(curl -sf --max-time 8 \
        -H "User-Agent: weather.sh/1.0" \
        "https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json" \
        | awk -F'"' '{
            for (i = 1; i <= NF; i++) {
                if ($i == "city" || $i == "town" || $i == "village" || $i == "municipality") {
                    print $(i+2); exit
                }
            }
        }') || die "could not reach Nominatim for reverse geocoding"
    [[ -n "$city" ]] || die "could not resolve a city name from coordinates (${lat}, ${lon})"
    printf '%s\n' "$city"
}

validate_location() {
    local loc="$1"
    local url_loc response
    url_loc=$(printf '%s' "$loc" | tr -s '[:space:]' '+')
    response=$(curl -sf --max-time 8 "https://wttr.in/${url_loc}?format=%t" 2>/dev/null) \
        || return 1
    [[ "$response" =~ ^[+-]?[0-9]+°[CcFf]$ ]]
}

# ── subcommands ───────────────────────────────────────────────────────────────

cmd="${1:-}"

case "$cmd" in

    temp|temperature)
        fetch "%t" | sed 's/^[+]//; s/°[CcFf]$/°/'
        ;;

    condition|weather)
        fetch "%C"
        ;;

    location|town|city)
        raw=$(fetch "%l")
        if [[ "$raw" =~ ^-?[0-9]+\.[0-9]+,-?[0-9]+\.[0-9]+$ ]]; then
            lat="${raw%%,*}"
            lon="${raw##*,}"
            reverse_geocode "$lat" "$lon"
        else
            printf '%s\n' "$raw"
        fi
        ;;

    set-location)
        [[ -z "${2:-}" ]] && die "set-location requires a city name, or 'delete' to clear"
        if [[ "${2}" == "delete" ]]; then
            if [[ -f "$CONFIG" ]]; then
                rm "$CONFIG"
                printf 'location cleared - reverted to IP auto-detection\n'
            else
                printf 'no saved location to delete\n'
            fi
        else
            printf 'checking "%s" with wttr.in...\n' "$2" >&2
            validate_location "$2" \
                || die "'${2}' was not recognised as a valid location - config not changed"
            mkdir -p "$(dirname "$CONFIG")"
            printf '%s\n' "$2" > "$CONFIG"
            printf 'location saved → %s\n' "$2"
            printf '(run set-location delete to clear and return to IP auto-detection)\n'
        fi
        ;;

    ""|-h|--help)
        usage
        ;;

    *)
        die "unknown command '${1}' — run with --help for usage"
        ;;

esac
