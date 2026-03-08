#!/usr/bin/env bash

OPTION=$(echo -e "Search Anime\nSettings" | rofi -dmenu -theme ~/.config/rofi/launchers/type-6/style-3.rasi -p "Ani-CLI:" -theme-str "entry { placeholder: 'Ani-Cli'; }")

case "$OPTION" in
    "Search Anime")
        QUERY=$(rofi -dmenu -theme ~/.config/rofi/launchers/type-6/style-3.rasi -p "Enter title:" -theme-str "entry { placeholder: 'Search for anime…'; }")
        ~/.config/ani-cli/ani-cli-rofi.sh "$QUERY"
        ;;
    "Settings")
        # Just edit the settings file with rofi prompts
        DUB=$(echo -e "true\nfalse" | rofi -dmenu -theme ~/.config/rofi/launchers/type-6/style-3.rasi -p "Dub?" -theme-str "entry { placeholder: 'Dub?'; }")
        QUALITY=$(echo -e "1080p\n720p\n360p" | rofi -dmenu -theme ~/.config/rofi/launchers/type-6/style-3.rasi -p "Quality?" -theme-str "entry { placeholder: 'Quality?'; }")
        MODE=$(echo -e "stream\ndownload" | rofi -dmenu -theme ~/.config/rofi/launchers/type-6/style-3.rasi -p "Mode?" -theme-str "entry { placeholder: 'Mode?'; }")
        
        # Save to settings.conf
        cat > ~/.config/ani-cli/settings.conf <<EOF
DUB=$DUB
QUALITY=$QUALITY
MODE=$MODE
EOF
        ;;
esac

