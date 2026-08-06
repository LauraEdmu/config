#!/usr/bin/env bash
# setup-shell-debian.sh
#
# Sets up the Zsh environment for root and laura on Debian-based systems.
# Run with:
#   sudo bash setup-shell-debian.sh

set -Eeuo pipefail

readonly LAURA_USER="laura"

readonly ZSHRC_URL="https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/bash-zsh/.zshrc"
readonly P10K_CONFIG_URL="https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/bash-zsh/.p10k.zsh"

readonly OMZ_REPO="https://github.com/ohmyzsh/ohmyzsh.git"
readonly P10K_REPO="https://github.com/romkatv/powerlevel10k.git"

readonly PLUGIN_REPOS=(
  "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions.git"
  "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting.git"
  "zsh-completions|https://github.com/zsh-users/zsh-completions.git"
  "zsh-z|https://github.com/agkozak/zsh-z.git"
)

trap 'printf "Error: setup failed on line %d\n" "$LINENO" >&2' ERR

if (( EUID != 0 )); then
  echo "Run this script as root, for example:"
  echo "  sudo bash $0"
  exit 1
fi

echo "Installing required packages..."

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
  zoxide \
  zsh

ZSH_BIN="$(command -v zsh)"

echo "Ensuring the ${LAURA_USER} user exists..."

if ! id "$LAURA_USER" &>/dev/null; then
  useradd \
    --create-home \
    --user-group \
    --shell "$ZSH_BIN" \
    "$LAURA_USER"
fi

usermod --shell "$ZSH_BIN" root
usermod --shell "$ZSH_BIN" "$LAURA_USER"

run_as_user() {
  local user="$1"
  local home="$2"
  shift 2

  if [[ "$user" == "root" ]]; then
    HOME="$home" USER="$user" LOGNAME="$user" "$@"
  else
    runuser -u "$user" -- \
      env HOME="$home" USER="$user" LOGNAME="$user" "$@"
  fi
}

clone_if_missing() {
  local user="$1"
  local home="$2"
  local repo="$3"
  local destination="$4"
  local group

  group="$(id -gn "$user")"

  if [[ -e "$destination" ]]; then
    echo "Already present: $destination"
    return
  fi

  install -d \
    -o "$user" \
    -g "$group" \
    -m 0755 \
    "$(dirname "$destination")"

  run_as_user "$user" "$home" \
    git clone --depth=1 "$repo" "$destination"
}

install_remote_file() {
  local user="$1"
  local url="$2"
  local destination="$3"
  local group
  local temporary_file

  group="$(id -gn "$user")"
  temporary_file="$(mktemp)"

  curl -fsSL "$url" -o "$temporary_file"

  install \
    -o "$user" \
    -g "$group" \
    -m 0644 \
    "$temporary_file" \
    "$destination"

  rm -f "$temporary_file"
}

setup_shell() {
  local user="$1"
  local home="$2"
  local group
  local plugin_entry
  local plugin_name
  local plugin_repo

  group="$(id -gn "$user")"

  echo
  echo "Setting up Zsh for $user..."

  install -d \
    -o "$user" \
    -g "$group" \
    -m 0755 \
    "$home"

  clone_if_missing \
    "$user" \
    "$home" \
    "$OMZ_REPO" \
    "$home/.oh-my-zsh"

  clone_if_missing \
    "$user" \
    "$home" \
    "$P10K_REPO" \
    "$home/.oh-my-zsh/custom/themes/powerlevel10k"

  for plugin_entry in "${PLUGIN_REPOS[@]}"; do
    IFS="|" read -r plugin_name plugin_repo <<< "$plugin_entry"

    clone_if_missing \
      "$user" \
      "$home" \
      "$plugin_repo" \
      "$home/.oh-my-zsh/custom/plugins/$plugin_name"
  done

  install_remote_file \
    "$user" \
    "$ZSHRC_URL" \
    "$home/.zshrc"

  install_remote_file \
    "$user" \
    "$P10K_CONFIG_URL" \
    "$home/.p10k.zsh"
}

LAURA_HOME="$(getent passwd "$LAURA_USER" | cut -d: -f6)"

if [[ -z "$LAURA_HOME" ]]; then
  echo "Could not determine the home directory for $LAURA_USER." >&2
  exit 1
fi

setup_shell root /root
setup_shell "$LAURA_USER" "$LAURA_HOME"

echo
echo "Shell setup complete."
echo "Root shell:  $ZSH_BIN"
echo "Laura home:  $LAURA_HOME"
