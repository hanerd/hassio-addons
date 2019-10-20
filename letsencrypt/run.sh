#!/bin/bash
set -e

CERT_DIR=/data/letsencrypt
WORK_DIR=/data/workdir
CONFIG_PATH=/data/options.json

EMAIL=$(jq --raw-output ".email" $CONFIG_PATH)
DOMAINS=$(jq --raw-output ".domains[]" $CONFIG_PATH)
KEYFILE=$(jq --raw-output ".keyfile" $CONFIG_PATH)
CERTFILE=$(jq --raw-output ".certfile" $CONFIG_PATH)
GCLOUDKEYFILE=$(jq --raw-output ".gcloudkeyfile" $CONFIG_PATH)

mkdir -p "$CERT_DIR"

# Generate new certs
if [ ! -d "$CERT_DIR/live" ]; then
    DOMAIN_ARR=()
    for line in $DOMAINS; do
        DOMAIN_ARR+=(-d "$line")
    done

    echo "$DOMAINS" > /data/domains.gen
    certbot certonly --non-interactive --dns-google --dns-google-credentials "$GCLOUDKEYFILE" --email "$EMAIL" --agree-tos --config-dir "$CERT_DIR" --work-dir "$WORK_DIR" "${DOMAIN_ARR[@]}"

# Renew certs
else
    certbot renew --non-interactive --config-dir "$CERT_DIR" --work-dir "$WORK_DIR" --dns-google --dns-google-credentials "$GCLOUDKEYFILE"
fi

# copy certs to store
cp "$CERT_DIR"/live/*/privkey.pem "/ssl/$KEYFILE"
cp "$CERT_DIR"/live/*/fullchain.pem "/ssl/$CERTFILE"
