#!/bin/bash

CACHE_DIR="/tmp/spotify-art"
mkdir -p "$CACHE_DIR"

playerctl --follow metadata --format '{{title}}|{{artist}}|{{mpris:artUrl}}|{{album}}' | \
while IFS="|" read -r title artist arturl album; do

    # Skip empty
    [ -z "$title" ] && continue

    ART_FILE="$CACHE_DIR/cover.jpg"

    if [ -n "$arturl" ]; then
        curl -s "$arturl" -o "$ART_FILE"
        ICON="$ART_FILE"
    else
        ICON="spotify"
    fi

    notify-send --app-name="Spotify" -i "$ICON" "$title" "$artist • $album"
done
