Option 2 (Bonus): Use systemd user service (advanced)

This option runs ssh-agent as a background user service independent of your shell.

    Create the systemd user directory if it doesn't exist:

mkdir -p ~/.config/systemd/user

    Create the service file:

nano ~/.config/systemd/user/ssh-agent.service

    Paste the following:

[Unit]
Description=SSH key agent

[Service]
Type=forking
ExecStart=/usr/bin/ssh-agent -a $XDG_RUNTIME_DIR/ssh-agent.socket

[Install]
WantedBy=default.target

    Enable and start the service:

systemctl --user enable ssh-agent
systemctl --user start ssh-agent

    Then add this to your ~/.bashrc or ~/.zshrc to connect your shell to the agent and add keys:

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_rsa

To avoid repeated prompts, you have a few options:
1. Use a Keychain manager (recommended)

    Install the keychain package, which manages your ssh-agent and key passphrase caching more elegantly.

    sudo apt install keychain

eval $(keychain --eval --agents ssh id_rsa)

