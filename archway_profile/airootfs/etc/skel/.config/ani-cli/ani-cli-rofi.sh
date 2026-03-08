#!/usr/bin/env bash

# Load settings
source ~/.config/ani-cli/settings.conf

# Take the search phrase as argument
SEARCH="$1"

# Build ani-cli command
CMD="ani-cli --rofi"
[ "$MODE" = "download" ] && cmd+=" --download"
[ "$DUB" = true ] && CMD+=" --dub"
CMD+=" --quality $QUALITY \"$SEARCH\""

# Run it
echo "$CMD"
eval "$CMD"

