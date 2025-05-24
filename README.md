<br>
<h1 align="center">Minimal Debian</h1>
<br>

Welcome to a minimalist Debian 12 setup — a streamlined, non-graphical (partly) environment built from the ground up to embrace the modern Wayland protocol. This project is designed for users who value simplicity, efficiency, performance and (optionally) privacy and security for their systems.

This is an opinionated, personal project, for my own use. Please don't attempt to run it on your own system and I take no responsibillity for what happens to your system, if you attempt to do so.

## Why Debian?

I am a freaking grandpa...jokes aside, I just want things to work...and grandaddy know how to dooooo :P 

## Read before executing

What are distros, but some choices already decided for you; same thing here, you run those scripts, this is what you will end up with...

- Bootloader - `grub`
 
- Display Manager - [greetd](https://wiki.archlinux.org/title/Greetd) a minimal and flexible login manager daemon; operates without the need for a graphical environment, aligning with my requirements for a non-graphical login manager.

- Window Manager - [Sway](https://swaywm.org/) is a dynamic tiling window manager and Wayland compositor that offers a fast, keyboard-driven workflow; with a focus on simplicity, Sway is lightweight and resource-efficient.

- Status Bar - [Waybar](), a highly customizable Wayland bar for Sway and Wlroots based compositors.

- Notifications Deamon - [](),

- Terminal Emulator - [](), 

- Terminal Multiplexer - [](),

- Application Launcher - [](),

- File Manager - []()[^1]

- Clipboard Manager (wl-clipboard)

- Network Manager? https://en.wikipedia.org/wiki/Wicd

- [x] Sound Support (PipeWire)

Minimal GUI (Pavucontrol)??

  - [PulseAudio-clt](https://github.com/graysky2/pulseaudio-ctl)

  - [PulseMixer](https://github.com/GeorgeFilipkin/pulsemixer)

  - [Pa Volume Control](https://github.com/geigerzaehler/pa-volume-control)

  - [Volumectl](https://github.com/kovetskiy/volumectl)

- [Flatpak]()

## System Components

- [ ] Package Manager Frontend - Synaptic?
- [ ] Backup Tool/File Syncing?

fsearch - search tool

## Firewall

- [GuFW](https://github.com/costales/gufw)
- [OpenSwitch](https://github.com/evilsocket/opensnitch)

## AntiVirus

- [ClamAV](https://www.clamav.net/)
- [ClamTK]()

## File Manager (GUI)


## Application Launcher

- [Fuzzel](https://codeberg.org/dnkl/fuzzel)
- [Tofi](https://github.com/philj56/tofi)
- [uLauncher]()

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
 
## Getting Started - How to use this?

Execute the scripts, per folder and per boot

- Initial Boot Sequence (1st Boot)
- 2nd Boot - Debloat, System Optimization
  - Debloat System (Reduce Attack Surface & Footprint)
  - Speed up boot-time 
- 3rd Boot - System Security & Hardening
- 4th Boot - Setting up the "Desktop" Enviroment
- 5th Boot - Setting up Personal Workspace

Software - grub customizer

## First Boot (initial boot)

1. Fix Apt Sources

   - Comment out the cdrom line on /etc/apt/sources.list
   - sudo apt update && sudo apt full-upgrade && sudo apt dist-upgrade

2. Add Additional Repositories

   - sudo add-apt-repository non-free
   - sudo add-apt-repisitory contrib
   - sudo apt update && sudo apt upgrade -y

3. Unattended Upgrades

  - sudo apt install unattended-upgrades
  - sudo dpkg-reconfigure --priority=low unattended-upgrades

4. Create a non-root user account??

## Second Boot (Debloat, System Optimization)

1. Debloat System (Reduce Footprint)

  - remove pre-installed applications
  - remove uncessary tools (since I am going to install my own preferences)

2. Speed up boot-time 

  - Minimizing GRUB boot-options Timeout

    - sudo micro /etc/default/grub
    - GRUB_TIMEOUT=0
    - sudo update-grub

3. Services Optimization

    - sudo systemctl list-unit-files --type=service  
    
    - systemd-analyze blame

    - systemctl disable [].service

4. Disable Mitigations

    - micro /etc/default/grub
    - GRUB_CMDLINE_LINUX="quiet mitigations=off"

5. ZSwap

    - micro /etc/default/grub
    - GRUB_CMDLINE_LINUX="zswap.enabled=1 quiet"

    zswap.zpool=z3fold zswap.compressor=lz4

    - micro /etc/initramfs-tools/modules
    - append z3fold
    - sudo update-initramfs -u

    To verify

    - dmesg | grep zswap

6. Disable Splash + Readahead Profiling

    - micro /etc/default/grub
    - remove quiet splash and replace with profile
    - sudo update-grub

7. Optimize CPU Performance

    - sudo apt install cpufrequtils
    - sudo cpufreq-set -g performance

    This sets the CPU governor to 'performance' mode, maximizing CPU speed
    
    - autocpufreq 

8. Optimize Swap Usage

    - micro /etc/sysctl.conf

    - vm.swappiness = 10

    - sudo sysctl -p

9. Tune Disk I/O Performance

  - sudo blockdev --setra 65536 /dev/sdX

10. Power Management?

11. Preload - keeps frequent apps in memory so they load faster

  - sudo apt install preload
  - sudo systemctl enable --now preload
  
## Third Boot (System Security, Hardening)

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

    - micro /etc/ssh/sshd_config
    - PermitRootLogin no

3. Change SSH Default Port

4. Disabling SSH Password Authentication

5. Set up another firewall on top of that?

  - PortMaster?
  - OpenSnitch?

6. Implement Intrusion Prevention with Fail2Ban

  - sudo apt install fail2ban
  - sudo systemctl enable fail2ban
  
7. Protect System Against Rootkits

  - https://linuxhint.com/install_chkrootkit/

8. Configure sysctl: Edit /etc/sysctl.conf to harden network settings.

  - net.ipv4.icmp_echo_ignore_broadcasts = 1
  - net.ipv4.conf.all.rp_filter = 1
  - net.ipv4.tcp_syncookies = 1

7. Prioritizing Repositories

8. Sandboxing

  - [Flatseal](https://github.com/tchx84/flatseal)

  - Firejail/Firetools?

6. Application-Level Security


  6.1. Implement Mandatory Access Controls (MAC)

    - sudo apt install apparmor apparmor-profiles apparmor-utils
    - sudo systemctl enable apparmor
    - sudo systemctl start apparmor

  - SELinux

7. Automated Security Auditing with Harbian Audit

    ```
    sudo apt install -y bc net-tools pciutils network-manager
    git clone https://github.com/hardenedlinux/harbian-audit.git
    cd harbian-audit
    sudo cp etc/default.cfg /etc/default/cis-hardening
    sudo sed -i "s#CIS_ROOT_DIR=.*#CIS_ROOT_DIR='$(pwd)'#" /etc/default/cis-hardening
    sudo bin/hardening.sh --init
    sudo bin/hardening.sh --set-hardening-level 3
    sudo bin/hardening.sh --apply
    ```

9. Implement Kernel Hardening Techniques

    Enhance kernel security by enabling features like Address Space Layout Randomization (ASLR) and restricting core dumps.

    - micro /etc/sysctl.conf
    
    - kernel.randomize_va_space = 2
    - fs.suid_dumpable = 0

    - sudo sysctl -p

10. Automated Security Hardening

    Utilize tools like Bastille and harden to automate the hardening process:

    - sudo apt install bastille harden

11. Encrypt Home Folder - https://jumpcloud.com/blog/how-to-encrypt-ubuntu-20-04-desktop-post-installation
   or Veracrypt
   
Steps to Encrypt Your Home Directory with eCryptfs

  - sudo apt install ecryptfs-utils
  - sudo ecryptfs-migrate-home -u your_username
  Retrieve and securely store the randomly generated mount passphrase
  - ecryptfs-unwrap-passphrase
  - mount | grep ecryptfs

12. Swap Encryption: If your system uses swap space, ensure it's encrypted to prevent sensitive data from being written in plaintext.

13. Temporary Directories: Consider mounting /tmp and /var/tmp as tmpfs to keep temporary files in RAM, reducing the risk of sensitive data being written to disk.

## 4th Boot - Setting up the "Desktop" Enviroment

1. Set up Package Manager (Nala)
  
  - sudo apt install nala

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


## Fifth Boot (Setting up Personal Workspace)

  - [Bleachbit](https://www.bleachbit.org/)

  - https://rmlint.readthedocs.io/en/latest/
  
  - https://www.nongnu.org/synaptic/

1. Install Microsoft Fonts

  - sudo nala install ttf-mscore-fonts-installer

2. Multimedia codecs? - ``sudo apt install libavcodex-extra```


```xdg-portal-gtk xdg-user-dirs```

## Footnotes

[^1]: My setup only supports a terminal-based file manager, if you want to go GUI, I recommend [Thunar](https://docs.xfce.org/xfce/thunar/start).

## Sources

- [x] [Choosing the Right Linux Distro](https://christitus.com/choose-linux-distro/)

- [x] [The Biggest Linux Security Mistakes by ChrisTitus](https://christitus.com/linux-security-mistakes/)

- [Speed-up Linux](https://christitus.com/speedup-linux/)

- [LinuxHint's - Security Hardening Checklist](https://linuxhint.com/linux_security_hardening_checklist/)

- https://static.open-scap.org/ssg-guides/ssg-fedora-guide-index.html

- https://jfearn.fedorapeople.org/fdocs/en-US/Fedora/20/html-single/Security_Guide/index.html

- https://www.cyberciti.biz/tips/linux-security.html

- https://github.com/shaurya-007/NSA-Linux-Hardening-docs

- [](https://www.youtube.com/watch?v=h1jOrlToaY0)

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
  