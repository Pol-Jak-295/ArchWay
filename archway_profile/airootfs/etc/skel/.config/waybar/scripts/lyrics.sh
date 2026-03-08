#!/usr/bin/env bash
exec waybar-lyric 2>/dev/null | sed -n 's/^[^{]*//p'

