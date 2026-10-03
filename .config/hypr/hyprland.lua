-- =============================================================================
-- 1. МОНИТОРЫ
-- =============================================================================
hl.monitor({
    output = "DP-2",
    mode = "1920x1080@180",
    position = "1920x0",
    scale = 1,
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

-- =============================================================================
-- 2. ВОРКСПЕЙСЫ (Исправлена ошибка: теперь default передается только для 1 и 6)
-- =============================================================================
for ws = 1, 5 do
    if ws == 1 then
        hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-2", default = true })
    else
        hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-2" })
    end
end

for ws = 6, 10 do
    if ws == 6 then
        hl.workspace_rule({ workspace = tostring(ws), monitor = "HDMI-A-1", default = true })
    else
        hl.workspace_rule({ workspace = tostring(ws), monitor = "HDMI-A-1" })
    end
end

-- =============================================================================
-- 3. ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ (NVIDIA)
-- =============================================================================
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")
hl.env("NVD_BACKEND", "direct")
hl.env("WLR_DRM_DEVICES", "/dev/drm/card1")
hl.env("SDL_VIDEO_FULLSCREEN_DISPLAY", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")

-- =============================================================================
-- 4. ПРАВИЛА ОКОН
-- =============================================================================
--hl.window_rule({ match = { class = "firefox" }, workspace = "7" })
--hl.window_rule({ match = { class = "discord" }, workspace = "8", opacity = 1.0 })
--hl.window_rule({ match = { class = "cs2" }, fullscreen = true, monitor = "DP-2" })
hl.window_rule({ suppress_event = "maximize" })
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })
-- =============================================================================
-- 5. ОСНОВНЫЕ НАСТРОЙКИ
-- =============================================================================
hl.config({

    

    cursor = {
        no_hardware_cursors = true,
    },
    render = {
        direct_scanout = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    input = {
        kb_layout = "us,ru",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        --sensitivity = -0.6,
    },
    device = {
        {
            name = "cx-wireless-mouse--1k-dongle-mouse",
            sensitivity = -0.7,
        }
    },
    general = {
        gaps_in = 3,
        gaps_out = 10,
        border_size = 0,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 2,
            passes = 3,
            new_optimizations = true,
            xray = false,
        },
        shadow = {
            enabled = true,
        },
    },
  
    misc = {
        always_follow_on_dnd = true,
        layers_hog_keyboard_focus = true,
        animate_manual_resizes = false,
    --    new_window_takes_over_fullscreen = 2,   
    },

})

-- ==========================================
-- 1. Исправленная регистрация кривых Безье
-- ==========================================
hl.curve("myBezier", { type = "bezier", points = { {0.09, 0.9}, {0.1, 1.05} } })
hl.curve("fluent_decel", { type = "bezier", points = { {0.1, 1}, {0, 1} } })
hl.curve("easeInOutCirc", { type = "bezier", points = { {0.85, 0}, {0.15, 1} } })
hl.curve("shot", { type = "bezier", points = { {0.2, 1}, {0.2, 1} } })
hl.curve("wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1} } })
hl.curve("bounce", { type = "bezier", points = { {0.2, 1.2}, {0.2, 1} } })
hl.curve("spring", { type = "bezier", points = { {0.22, 1.25}, {0.36, 1.1} } })

-- ==========================================
-- 2. Исправленная настройка анимаций
-- ==========================================

-- Окна (Глобально)
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 8,
    bezier = "bounce",
    style = "popin 80%"
})

-- Закрытие окон
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 7,
    bezier = "winOut",
    style = "popin 80%"
})

-- Перемещение окон
hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 8,
    bezier = "wind",
    style = "slide"
})

-- Границы окон
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "default" -- Использует дефолтную кривую Hyprland
})

-- Затухание (Fade)
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 8,
    bezier = "default"
})

-- Рабочие пространства
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 8,
    bezier = "bounce",
    style = "slide"
})


-- =============================================================================
-- 7. АВТОСТАРТ (Без хука, чтобы обои и скрипты восстанавливались при релоаде)
-- =============================================================================
local autostart_cmds = {
    "killall waybar; waybar",
    "waypaper --restore --no-post-command",
    'bash -c "sleep 2 && awww-daemon"',
    'bash -c "sleep 3 && ~/.config/hypr/scripts/wall.sh"',
    "killall mako; mako",
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "hyprpm reload -n",
    "killall hyprswitch; hyprswitch init &",
    --"hyprctl plugin load /home/stopnope/.local/share/hyprpm/Hyprspace/Hyprspace.so",
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    --"/home/stopnope/scripts/infinite-desktop.sh",
    "/home/stopnope/local/bin/proxy-toggle.sh",
    "/usr/lib/xdg-desktop-portal --replace",
    "~/.config/hypr/xdg-portal-init.sh",
    --"killall nwg-dock-hyprland; nwg-dock-hyprland -autohide -i 48 -mb 20",
    --"nwg-dock-hyprland -i 38 -w 5 -mb 10 -f -hd 0 -d",
    "killall nwg-dock-hyprland",
    
}





for _, cmd in ipairs(autostart_cmds) do
    hl.exec_cmd(cmd)
end

-- =============================================================================
-- Подключение файла биндов
-- =============================================================================
pcall(require, "keybind")
