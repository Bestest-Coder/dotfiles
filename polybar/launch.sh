#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config
polybar mainbar 2>&1 | tee -a /tmp/polybar.log & disown
if polybar -m | grep "HDMI"
    then
    polybar sidebar 2>&1 | tee -a /tmp/polybarside.log & disown
fi

if polybar -m | grep "DP-1-0"
    then
    polybar othersidebar 2>&1 | tee -a /tmp/polybarotherside.log $ disown
fi

echo "Polybar launched..."
