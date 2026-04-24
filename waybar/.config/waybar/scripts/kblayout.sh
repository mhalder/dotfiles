#!/usr/bin/env bash

layout=$(swaymsg -t get_inputs | jq -r '
  map(select(.type == "keyboard"))
  | .[0].xkb_active_layout_name // empty
')

case "$layout" in
  "English (US)")
    echo " US"
    ;;
  "English (US, intl., with dead keys)")
    echo " INTL"
    ;;
  "")
    echo " ?"
    ;;
  *)
    echo " $layout"
    ;;
esac
