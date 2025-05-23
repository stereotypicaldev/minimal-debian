<br>
<h1 align="center">Minimal Debian</h1>
<br>

Welcome to a minimalist Debian 12 setup — a streamlined, non-graphical (partly) environment built from the ground up to embrace the modern Wayland protocol. This project is designed for users who value simplicity, efficiency, performance and (optionally) privacy and security for their systems.

This is an opinionated, personal project, for my own use. Please don't attempt to run it on your own system and I take no responsibillity for what happens to your system, if you attempt to do so.

## Why Debian?

I am a freaking grandpa...jokes aside, I just want things to work...and grandaddy know how to dooooo :P 

## Without Further Audie

- Bootloader - `grub`
- Display Manger - `greetd`
- 

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

- First Boot
- System Performance Optimization
- Drivers
- Application Performance
- System Security

## First Boot (initial boot)

1. Fix Apt Sources

   - Comment out the cdrom line on /etc/apt/sources.list
   - Run sudo apt update && sudo apt full-upgrade && sudo apt dist-upgrade

2. Add Additional Repositories

   - sudo add-apt-repository non-free
   - sudo add-apt-repisitory contrib
   - sudo apt update && sudo apt upgrade -y

3. Unattended Upgrades

  - sudo apt install unattended-upgrades
  - sudo dpkg-reconfigure --priority=low unattended-upgrades

4. Create a non-root user account

## Second Boot

1. Debloat System (Reduce Footprint)

  - remove pre-installed applications
  - remove uncessary tools (since I am going to install my own preferences)

2. Speed up boot-time 

  - Minimizing GRUB boot-options Timeout

    - sudo micro /etc/default/grub
    - GRUB_TIMEOUT=0
    - sudo update-grub

3. Startup Applications & Services Optimizations

    - systemctl list-unit-files   
    
    - systemd-analyze

    - systemctl disable [].service

4. Disable Mitigations

    Software - grub customizer

    - micro /etc/default/grub
    - GRUB_CMDLINE_LINUX="quiet mitigations=off"

5. ZSwap

    - micro /etc/default/grub
    - GRUB_CMDLINE_LINUX="zswap.enabled=1 quiet"

6. Disable Splash + Readahead Profiling

    - micro /etc/default/grub
    - remove quiet splash and replace with profile
    - sudo update-grub

3. Nvidia Drivers? - caused problems in the past
  
  - sudo apt install nvidia-detect
  - nvidia-detect
  - sudo apt install nvidia-driver
  - sudo reboot



## Third Boot









2. Set up Package Manager (Nala)
  
  - sudo apt install nala




2. autocpufreq 

3. Power Management?

## Application Performance

1. Preload - keeps frequent apps in memory so they load faster

  - sudo apt install preload
  - sudo systemctl enable --now preload





1. Encrypt Home Folder - https://jumpcloud.com/blog/how-to-encrypt-ubuntu-20-04-desktop-post-installation
   or Veracrypt


7. 
  - https://wiki.debian.org/ReduceDebian
  - https://github.com/jazir555/Linux-Performance-Optimizations/blob/main/performance%20optimizations.txt
  - https://gist.github.com/dante-robinson/cd620c7283a6cc1fcdd97b2d139b72fa
  - https://github.com/sahilshekhawat/Optimizing-Linux-Performance-A-Hands-On-Guide-to-Linux-Performance-Tools
  - https://github.com/hawshemi/linux-optimizer
  - https://github.com/jazir555/Linux-Performance-Optimizations
  - zswap - https://github.com/M-Gonzalo/zramd
  - Update to systemd 254 or higher
  - https://blog.frehi.be/2011/05/27/linux-performance-improvements/
  - https://www.siberoloji.com/how-to-optimize-disk-io-performance-in-debian-12-bookworm/
  - https://shape.host/resources/optimizing-network-performance-enabling-bbr-on-debian-12-step-by-step
  - https://infotechys.com/tips-for-optimizing-your-ubuntu-debian/
  - https://medium.com/@charles.vissol/optimize-your-linux-69c70320d852
  - https://www.siberoloji.com/how-to-configure-system-services-for-high-performance-on-debian-12/
  - https://github.com/sn99/Optimizing-linux
  - https://www.fosslinux.com/111937/tips-and-tricks-for-optimizing-linux-device-performance.htm
  - https://qref.sourceforge.net/Debian/reference/ch-tune.en.html
  - https://www.turbogeek.co.uk/optimize-linux/
  - https://www.debian.org/doc/manuals/debian-reference/ch09
  - https://mihirpopat.medium.com/top-tips-to-optimize-your-linux-system-make-your-machine-faster-and-more-efficient-4301afa349a5
  - 
  
6. Startup Applications & Services

  - ~/.config/autostart - folder which most startup applications is installed
  -  Stacer Application

6. Linux Headers

  - sudo nala install linux-headers-$(uname -r)
  - firmware-linux
  - firmware-linux-nonfree
  - vulk
  - an-tools
  - vulkan-validationlayers
  - unrar
  - gstreamer1.0-vaapi
  - clang
  - bpytop
  - cargo
  - libc6-i386
  - libc6-x32
  - libu2f-udev
  - samba-common-bin
  - exfat-fuse

## System Security

> Security is a journey, not a destination.

1. Setting up a Firewall

  - ufw
  - firewalld
  - iptables 
  - nfttables

  Recommended Rules 

  ```
  sudo ufw limit 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable
  ```

2. Disable SSH Root Access

3. Change SSH Default Port

4. Disabling SSH Password Authentication

5. Set up another firewall on top of that?

  - PortMaster?
  - OpenSnitch?

6. Fail2Ban (intrusion prevention utility)

  ```
  sudo apt install fail2ban
  ```

7. Protect System Against Rootkits

  - https://linuxhint.com/install_chkrootkit/


7. Prioritizing Repositories

8. Sandboxing

  - FlatSeal
  - Firejail/Firetools?

6. Application-Level Security

  - AppArmor
  - SELinux






3. Antivirus

  - ClamAV/ClamTK - 




## System Privacy 

  - Bleachbit
  - https://www.bleachbit.org/
  - https://rmlint.readthedocs.io/en/latest/
  - https://www.nongnu.org/synaptic/




## Miscelleanious (Personal)

1. Install Microsoft Fonts

  - sudo nanla install ttf-mscore-fonts-installer

2. Multimedia codecs? - ``sudo apt install libavcodex-extra```

















## System Components

- [x] Sound Support (PipeWire) + Minimal GUI (Pavucontrol)
- [x] Clipboard Capabillity (wl-clipboard)
- [x] File Manager - 
- [x] Status Bar - 
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

- [Alacritty](https://github.com/alacritty/alacritty) - A cross-platform, GPU-accelerated terminal emulator

- Foot - A fast, lightweight and minimalistic Wayland terminal emulator

- [Kitty](https://sw.kovidgoyal.net/kitty/) - A cross-platform, fast, feature-full, GPU-based terminal emulator

- [Rxvt](https://wiki.archlinux.org/title/Rxvt-unicode) - 
- https://ghostty.org/
 
 https://tabby.sh/
 
## Sources

- [Choosing the Right Linux DIstro](https://christitus.com/choose-linux-distro/)

- [The Biggest Linux Security Mistakes by ChrisTitus](https://christitus.com/linux-security-mistakes/)

- [LinuxHint's - Security Hardening Checklist](https://linuxhint.com/linux_security_hardening_checklist/)

https://static.open-scap.org/ssg-guides/ssg-fedora-guide-index.html

https://jfearn.fedorapeople.org/fdocs/en-US/Fedora/20/html-single/Security_Guide/index.html

https://www.cyberciti.biz/tips/linux-security.html

https://github.com/shaurya-007/NSA-Linux-Hardening-docs

- [Speed-up Linux](https://christitus.com/speedup-linux/)

- [](https://www.youtube.com/watch?v=h1jOrlToaY0)