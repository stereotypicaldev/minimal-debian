#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# Script to install ungoogled Chromium Flatpak with Wayland + xdg-open support
# Optimized for Debian 12 Bookworm (minimal dependencies)
#
# - Installs ungoogled Chromium via Flatpak (user scope)
# - Edits all Exec= entries in the .desktop file for Wayland support
# - Enables full support for xdg-open using flatpak-spawn --host
# - Sets Flatpak environment overrides for persistent behavior
# - Ensures compatibility with Wayland-native launchers (fuzzel, tofi, etc.)
# ------------------------------------------------------------------------------

APP_ID="io.github.ungoogled_software.ungoogled_chromium"
DESKTOP_FILE="${APP_ID}.desktop"
USER_APP_DIR="${HOME}/.local/share/applications"
FLATPAK_EXPORT_DIR="${HOME}/.local/share/flatpak/exports/share/applications"
FLATPAK_DESKTOP_FILE="${FLATPAK_EXPORT_DIR}/${DESKTOP_FILE}"
LOCAL_DESKTOP_FILE="${USER_APP_DIR}/${DESKTOP_FILE}"

CHROMIUM_FLAGS=(
  --enable-features=UseOzonePlatform
  --ozone-platform=wayland
  --external-launcher="flatpak-spawn --host xdg-open"
)
WAYLAND_ENV="MOZ_ENABLE_WAYLAND=1"

TMP_FILE="$(mktemp)"
cleanup() {
  [[ -f "$TMP_FILE" ]] && rm -f "$TMP_FILE"
}
trap cleanup EXIT INT TERM

log() {
  echo "[+] $1"
}

error_exit() {
  echo "[!] Error: $1" >&2
  exit 1
}

log "Checking for Flatpak..."
command -v flatpak >/dev/null 2>&1 || error_exit "flatpak is not installed"

log "Installing ungoogled Chromium via Flatpak (user scope)..."
flatpak install --user -y flathub "$APP_ID" >/dev/null 2>&1 || error_exit "Flatpak install failed"

log "Preparing local .desktop override..."
mkdir -p "$USER_APP_DIR"
[[ -f "$FLATPAK_DESKTOP_FILE" ]] || error_exit "Desktop file not found"
cp -f "$FLATPAK_DESKTOP_FILE" "$LOCAL_DESKTOP_FILE"

patch_exec_line() {
  local section="$1"
  local extra_flag="$2"
  local new_exec="Exec=env ${WAYLAND_ENV} flatpak run ${APP_ID} ${CHROMIUM_FLAGS[*]} ${extra_flag}"

  awk -v section="$section" -v newexec="$new_exec" '
    $0 == "[" section "]" { in_section = 1 }
    in_section && /^Exec=/ { $0 = newexec; in_section = 0 }
    { print }
  ' "$LOCAL_DESKTOP_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$LOCAL_DESKTOP_FILE"
}

log "Patching Exec= line in .desktop file for native Wayland..."
patch_exec_line "Desktop Entry" ""

grep -q "^\[Desktop Action NewWindow\]" "$LOCAL_DESKTOP_FILE" && \
  patch_exec_line "Desktop Action NewWindow" ""

grep -q "^\[Desktop Action Incognito\]" "$LOCAL_DESKTOP_FILE" && \
  patch_exec_line "Desktop Action Incognito" "--incognito"

log "Applying Flatpak overrides (Wayland + Downloads only)..."
flatpak override --user \
  --env=MOZ_ENABLE_WAYLAND=1 \
  --env=DEFAULT_BROWSER_COMMAND="flatpak-spawn --host xdg-open" \
  --filesystem=xdg-download \
  --socket=wayland \
  --socket=fallback-x11 \
  --talk-name=org.freedesktop.portal.FilenameRequester \
  --talk-name=org.freedesktop.portal.OpenURI \
  --talk-name=org.freedesktop.portal.Launcher \
  --persist="${APP_ID}" \
  "$APP_ID" >/dev/null 2>&1 || true

if command -v update-desktop-database >/dev/null 2>&1; then
  log "Updating desktop database..."
  update-desktop-database "$USER_APP_DIR" >/dev/null 2>&1 || true
fi

log "Setup complete: Chromium is now sandboxed with Wayland + xdg-open support."
