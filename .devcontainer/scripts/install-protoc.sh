#!/usr/bin/env bash

PROTOC_VERSION="3.20.0"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Install protoc compiler
architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="x86_64";;
    aarch64 | armv8*) architecture="aarch_64";;
    i?86) architecture="x86_32";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

PROTOC_ZIP=protoc-${PROTOC_VERSION}-linux-${architecture}.zip
curl -LO "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/${PROTOC_ZIP}"
unzip -o "${PROTOC_ZIP}" -d /usr/local bin/protoc
chmod -R 755 /usr/local/bin/protoc
unzip -o "${PROTOC_ZIP}" -d /usr/local 'include/*'
chmod -R 755 /usr/local/include/google/protobuf
rm -f "${PROTOC_ZIP}"
