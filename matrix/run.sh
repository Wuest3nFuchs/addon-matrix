#!/usr/bin/env bash
set -euo pipefail


# Pfade
CONFIG_DIR="/data"
HOMESERVER_CONFIG="$CONFIG_DIR/homeserver.yaml"


# Lade Optionen falls vorhanden (Home Assistant legt options.json in runtime ab)
if [ -f /data/options.json ]; then
# einfache jq-free ersatz: read values with python to avoid jq dependency
SERVER_NAME=$(python3 -c "import sys, json
opts=json.load(open('/data/options.json'))
print(opts.get('server_name','matrix.local'))")
REGISTRATION_ENABLED=$(python3 -c "import sys, json
opts=json.load(open('/data/options.json'))
print(str(opts.get('enable_registration', False)).lower())")
else
SERVER_NAME="matrix.local"
REGISTRATION_ENABLED="false"
fi


# ensure config dir exists and perms
mkdir -p "$CONFIG_DIR"
chown -R synapse:synapse "$CONFIG_DIR" || true


# If no config exists, generate a minimal config
if [ ! -f "$HOMESERVER_CONFIG" ]; then
echo "No homeserver.yaml found — creating initial config for $SERVER_NAME"
# create a minimal homeserver.yaml using synapse config generator
python3 -m synapse.app.homeserver --server-name "$SERVER_NAME" --config-path "$HOMESERVER_CONFIG" generate
chown synapse:synapse "$HOMESERVER_CONFIG" || true
fi


# Optionale Umgebungs- oder Konfig-Änderungen je nach options.json
# (z.B. Registrierung erlauben/verbieten) – Synapse verwaltet das in registration.yaml


# Start Synapse
echo "Starting Synapse (homeserver config: $HOMESERVER_CONFIG)"
exec python3 -m synapse.app.homeserver --config-path "$HOMESERVER_CONFIG"
