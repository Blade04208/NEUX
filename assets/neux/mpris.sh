#!/usr/bin/env bash

MAX=48
WATCHDOG=${WATCHDOG:-5}
CACHE_DIR="$HOME/.cache/neux/mpris"
NOART="$HOME/.config/ironbar/noart.png"
ACTIVE_VAR=mpris_active

RECORD=$(printf '{{status}}\t{{title}}\t{{artist}}\t{{mpris:artUrl}}')

trap 'exit' INT TERM EXIT

trim() {
    local s="$1"
    if (( ${#s} > MAX )); then
        echo "${s:0:$((MAX-1))}…"
    else
        echo "$s"
    fi
}

resolve_art() {
    local uri="$1"
    mkdir -p "$CACHE_DIR"

    if [[ -z "$uri" ]]; then
        echo "$NOART"; return
    fi

    if [[ "$uri" == file://* ]]; then
        echo "${uri#file://}"

    elif [[ "$uri" == data:* ]]; then
        local b64="${uri#*,}"
        local hash
        hash=$(printf '%s' "$b64" | md5sum | cut -d' ' -f1)
        local path="$CACHE_DIR/$hash.png"
        if [[ ! -f "$path" ]]; then
            printf '%s' "$b64" | base64 -d > "$path" 2>/dev/null || { rm -f "$path"; echo "$NOART"; return; }
        fi
        find "$CACHE_DIR" -type f ! -name "$hash.png" -delete
        echo "$path"

    elif [[ "$uri" == http* ]]; then
        local hash
        hash=$(printf '%s' "$uri" | md5sum | cut -d' ' -f1)
        local path="$CACHE_DIR/$hash.png"
        if [[ ! -f "$path" ]]; then
            curl -sL --max-time 5 "$uri" -o "$path" 2>/dev/null || { rm -f "$path"; echo "$NOART"; return; }
        fi
        find "$CACHE_DIR" -type f ! -name "$hash.png" -delete
        echo "$path"

    else
        echo "$uri"
    fi
}

pick_player() {
    local p paused="" state
    for p in $(playerctl -l 2>/dev/null); do
        state=$(timeout 2 playerctl -p "$p" status 2>/dev/null)
        case "$state" in
            Playing) printf '%s' "$p"; return ;;
            Paused)  [[ -z "$paused" ]] && paused="$p" ;;
        esac
    done
    printf '%s' "$paused"
}

stream() {
    local field="$1"
    local player rec="" last="<unset>" visible="<unset>" out
    local status title artist art inactive

    case "$field" in art) inactive="$NOART" ;; *) inactive="Nothing Playing" ;; esac

    set_visible() {
        [[ "$visible" == "$1" ]] && return
        visible="$1"
        ironbar var set "$ACTIVE_VAR" "$1" >/dev/null 2>&1
    }

    while true; do
        player=$(pick_player)
        if [[ -z "$player" ]]; then
            set_visible false
            if [[ "$last" != "$inactive" ]]; then echo "$inactive"; last="$inactive"; fi
            sleep 1
            continue
        fi

        while IFS=$'\t' read -r status title artist art; do
            [[ "$rec" == "$status|$title|$artist|$art" ]] && continue
            rec="$status|$title|$artist|$art"

            if [[ "$status" == Playing || "$status" == Paused ]]; then
                set_visible true
                if [[ "$field" == art ]]; then
                    out=$(resolve_art "$art")
                else
                    out="${!field}"
                    [[ -n "$out" ]] || out="$inactive"
                    out=$(trim "$out")
                fi
            else
                set_visible false
                out="$inactive"
            fi

            [[ "$out" != "$last" ]] && { echo "$out"; last="$out"; }
        done < <(timeout "$WATCHDOG" playerctl -p "$player" metadata -f "$RECORD" -F 2>/dev/null)
    done
}

case "$1" in
    title|artist|art) stream "$1"   ;;
    *)
        echo "Usage: $0 {title|artist|art}"
        exit 1
        ;;
esac
