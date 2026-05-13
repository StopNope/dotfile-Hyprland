#!/bin/bash
# Укажи здесь ПУТЬ к своей папке с обоями
WALLPAPER_DIR="/home/stopnope/Wallpaper" 

# Проверяем, установлена ли папка
if [ ! -d "$WALLPAPER_DIR" ]; then
   notify-send "Ошибка" "Папка с обоями не найдена!"
   exit 1
fi

# Получаем список файлов и отправляем в wofi
SELECTED=$(ls "$WALLPAPER_DIR" | wofi --show dmenu --prompt "Выберите обои:")

# Если что-то выбрали — устанавливаем через awww
if [ -n "$SELECTED" ]; then
    awww img "$WALLPAPER_DIR/$SELECTED" --transition-type grow --transition-pos center --transition-duration 1
    sleep 1
fi

# Проверяем, запущен ли демон awww
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon & 
    sleep 1 # Даем секунду проснуться
fi
