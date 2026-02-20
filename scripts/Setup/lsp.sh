#!/usr/bin/env bash

set -euo pipefail

sudo apt update && sudo apt install -y nodejs npm # for various lsps

# ---- LUA ----

LUA_VER="3.17.1"
LUA_TGZ="lua-language-server-${LUA_VER}-linux-x64.tar.gz"
LUA_URL="https://github.com/LuaLS/lua-language-server/releases/download/${LUA_VER}/${LUA_TGZ}"
LUA_DIR="/opt/lua-language-server/${LUA_VER}"

TMP_LUA="$(mktemp /tmp/lua-lsp-XXXXXX.tar.gz)"
TMP_LUA_EXTR="$(mktemp -d /tmp/lua-lsp-XXXXXX)"

curl -fsSLo "$TMP_LUA" "$LUA_URL"
tar -xzf "$TMP_LUA" -C "$TMP_LUA_EXTR"

sudo rm -rf "$LUA_DIR"
sudo install -d -m 0755 "$LUA_DIR"
sudo cp -a "$TMP_LUA_EXTR/." "$LUA_DIR/"

# Small wrapper so editors can call `lua-language-server` from PATH
sudo tee /usr/local/bin/lua-language-server >/dev/null <<EOF
#!/usr/bin/env bash
exec "$LUA_DIR/bin/lua-language-server" "\$@"
EOF
sudo chmod 0755 /usr/local/bin/lua-language-server

rm -rf "$TMP_LUA" "$TMP_LUA_EXTR"

# ---- BASH ----

sudo npm install -g bash-language-server

# ---- PYTHON ----

sudo apt install -y python3-pylsp 

# ---- TOML ----

TMP_TOML="$(mktemp /tmp/toml-lsp-XXXXXX)"
TMP_TOML_GZ="$TMP_TOML.gz"

curl -fsSLo "$TMP_TOML_GZ" \
  'https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-x86_64.gz'

gzip -df "$TMP_TOML_GZ"

sudo install -m 0755 "$TMP_TOML" /usr/local/bin/taplo

rm -rf "$TMP_TOML" "$TMP_TOML_GZ"

# ---- YAML ----

npm install -g yaml-language-server

# ---- JSON ----

npm install -g vscode-langservers-extracted

# ---- MARKDOWN ----

TMP_MD="$(mktemp /tmp/MD-lsp-XXXXXX)"
curl -fsSLo "$TMP_MD" \
  'https://github.com/Feel-ix-343/markdown-oxide/releases/download/v0.25.10/markdown-oxide-v0.25.10-x86_64-unknown-linux-gnu'

sudo install -m 0755 "$TMP_MD" /usr/local/bin/markdown-oxide
rm -f "$TMP_MD"

