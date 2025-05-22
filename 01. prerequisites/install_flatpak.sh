sudo apt install flatpak

flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# modifies the runtime environment of Flatpak apps for the current user,
# overriding default settings to make GUI toolkits use Wayland instead of X11. 
flatpak --user override --env=GDK_BACKEND=wayland --env=QT_QPA_PLATFORM=wayland

