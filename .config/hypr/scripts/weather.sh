#!/bin/bash
# Тянем погоду для Тюмени (или своего города)
weather=$(curl -s "wttr.in/Tyumen?format=%c%t" | xargs)
if [ -z "$weather" ]; then
    echo "Нет сети"
else
    echo "$weather"
fi
