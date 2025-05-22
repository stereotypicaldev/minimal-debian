```
sudo apt install pipewire pipewire-audio-client-libraries pipewire-pulse pavucontrol wireplumber

# Enable PipeWire service
systemctl --user enable --now pipewire

# Enable and start PipeWire PulseAudio compatibility (if you want PulseAudio apps to work)
systemctl --user enable --now pipewire-pulse

# Set my Default Output (Personalized)
pactl set-default-sink alsa_output.pci-0000_08_00.1.pro-output-3
```