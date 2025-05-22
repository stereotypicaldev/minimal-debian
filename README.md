<br>
<h1 align="center">Minimal Debian</h1>
<br>

Welcome to a minimalist Debian 12 setup — a streamlined, non-graphical (partly) environment built from the ground up to embrace the modern Wayland protocol. This project is designed for users who value simplicity, efficiency, performance and (optionally) privacy and security for their systems.

## TO-DO

- [ ] Create a Script
- [ ] "Debloat" System Packages
- [ ] First Steps on new Operating System
- [ ] Optimize System Performance
- [ ] Optimize Network Performance
- [ ] Prerequisities (System Initiation)
    - Wayland Support
    - Sound Support
    - Sway, Waybar, etc. etc. 
- [ ] Sway Config
- [ ] Tofi/Ruffel Config
- [ ] Configure Waybar
    - [ ] Network

## System Components

- [x] Sound Support (PipeWire) + Minimal GUI (Pavucontrol)
- [x] Clipboard Capabillity (wl-clipboard)
- [x] File Manager
- [x] Status Bar
- [x] Application Launcher -


```xdg-portal-gtk xdg-user-dirs```

## Getting Started

This repository provides detailed instructions and scripts to set up your own minimal Debian 12 system following these principles.

- [greetd](https://wiki.archlinux.org/title/Greetd) a minimal and flexible login manager daemon; operates without the need for a graphical environment, aligning with my requirements for a non-graphical login manager.

- [Sway](https://swaywm.org/) is a dynamic tiling window manager and Wayland compositor that offers a fast, keyboard-driven workflow; with a focus on simplicity, Sway is lightweight and resource-efficient.

- [Waybar](), a highly customizable Wayland bar for Sway and Wlroots based compositors.

- [Flatpak]() + [Ungoogled Chromium]()

## Applications

- Application Launcher
- Compositor + Window Manager
- Notifications Deamon
- Terminal Emulator
  - Shell
- File Manager
- Firewall
- Flatpak + Browser

## Firewall

- [GuFW](https://github.com/costales/gufw)
- [OpenSwitch](https://github.com/evilsocket/opensnitch)

## AntiVirus

- [ClamAV](https://www.clamav.net/)

## File Manager (GUI)

- [Thunar]()
- [Nemo](https://github.com/linuxmint/nemo)
- [Dolphin](https://invent.kde.org/system/dolphin)

## Application Launcher

- [Fuzzel](https://codeberg.org/dnkl/fuzzel)
- [Tofi](https://github.com/philj56/tofi)

## Layouts

autotiling - switch the layout splith/splitv depending on the currently focused window dimensions.
autotiling-rs - Same idea as autotiling but implemented as a single binary instead of a python script.
persway - enforces spiral and main-stack layouts
swaymonad - an auto-tiler that implements Xmonad-like layouts.
papersway - PaperWM-style scrollable window management for sway/i3wm.

## Notification Center

- https://github.com/ErikReider/SwayNotificationCenter

- https://github.com/emersion/mako

## Terminal Emulators

- Alacritty - A cross-platform, GPU-accelerated terminal emulator

- Foot - A fast, lightweight and minimalistic Wayland terminal emulator

- Kitty - A cross-platform, fast, feature-full, GPU-based terminal emulator

- https://ghostty.org/
 
- https://st.suckless.org/
 
 https://tabby.sh/
 


