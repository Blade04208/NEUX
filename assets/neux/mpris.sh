#!/usr/bin/env bash

MAX=48
RETRY_DELAY=1
CACHE_DIR="$HOME/.cache/neux/mpris"
NOART="$HOME/.config/ironbar/noart.png"

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

stream_field() {
    local field="$1"
    local last="<unset>"

    while true; do
        while IFS= read -r val; do
            local out
            if [[ -z "$val" ]]; then
                out="Nothing Playing"
            else
                out=$(trim "$val")
            fi
            if [[ "$out" != "$last" ]]; then
                echo "$out"
                last="$out"
            fi
        done < <(playerctl metadata "$field" -F 2>/dev/null)

        if [[ "Nothing Playing" != "$last" ]]; then
            echo "Nothing Playing"
            last="Nothing Playing"
        fi
        sleep "$RETRY_DELAY"
    done
}

stream_art() {
    local last="<unset>"

    while true; do
        while IFS= read -r uri; do
            local out
            out=$(resolve_art "$uri")
            if [[ "$out" != "$last" ]]; then
                echo "$out"
                last="$out"
            fi
        done < <(playerctl metadata mpris:artUrl -F 2>/dev/null)

        if [[ "$NOART" != "$last" ]]; then
            echo "$NOART"
            last="$NOART"
        fi
        sleep "$RETRY_DELAY"
    done
}

status_now() {
    playerctl status 2>/dev/null || echo "Stopped"
}

fmt_time() {
    local s="${1%%.*}"
    s=$(printf '%s' "$s" | tr -cd '0-9')
    : "${s:=0}"
    s=$((10#$s))
    printf '%d:%02d' $((s / 60)) $((s % 60))
}

position_secs() {
    local pos
    pos=$(playerctl position 2>/dev/null)
    printf '%s' "${pos:-0}"
}

length_secs() {
    local len
    len=$(playerctl metadata mpris:length 2>/dev/null)
    printf '%s' "$(( ${len:-0} / 1000000 ))"
}

state_icon() {
    case "$(status_now)" in
        Playing) echo "icon:media-playback-pause-symbolic" ;;
        *)       echo "icon:media-playback-start-symbolic"  ;;
    esac
}

progress_pct() {
    local pos len
    pos=$(position_secs)
    len=$(length_secs)
    if (( len > 0 )); then
        awk -v p="$pos" -v l="$len" 'BEGIN { pct = p * 100 / l; if (pct > 100) pct = 100; if (pct < 0) pct = 0; printf "%.2f", pct }'
    else
        echo 0
    fi
}

case "$1" in
    title)       stream_field title  ;;
    artist)      stream_field artist ;;
    album)       stream_field album  ;;
    art)         stream_art          ;;
    status)      status_now          ;;
    state-icon)  state_icon          ;;
    position)    fmt_time "$(position_secs)" ;;
    length)      fmt_time "$(length_secs)"   ;;
    progress)    progress_pct        ;;
    *)
        echo "Usage: $0 {title|artist|album|art|status|state-icon|position|length|progress}"
        exit 1
        ;;
esac
