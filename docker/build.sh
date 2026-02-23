#!/bin/sh

set -xe

# Install gosu
if [ "$(uname -m)" = "aarch64" ]; then
  arch='arm64'
  checksum='3a8ef022d82c0bc4a98bcb144e77da714c25fcfa64dccc57f6aba7ae47ff1a44'
elif [ "$(uname -m)" = "armv7l" ]; then
  arch='armhf'
  checksum='8457a0bfd28e016c2c7d8ea6e5f7eed1376033ffbd36491bb455094c8b1dc9fd'
else
  arch='amd64'
  checksum='52c8749d0142edd234e9d6bd5237dff2d81e71f43537e2f4f66f75dd4b243dd0'
fi

wget --quiet "https://github.com/tianon/gosu/releases/download/1.19/gosu-${arch}" -O /usr/sbin/gosu
echo "${checksum}  /usr/sbin/gosu" | sha256sum -cs
chmod +x /usr/sbin/gosu

# Create wh user for webhook
addgroup -S wh
adduser -G wh -H -D -g 'webhook wh user' wh -s /sbin/nologin && usermod -p '*' wh

# Create default hooks.json
touch /app/hooks.json
cat << EOF > /app/hooks.json
[
    {
        "id": "default",
        "execute-command": "echo",
        "response-message": "I am working!"
    }
]
EOF

# Set permissions after all files are created
chown root:root -R /app
chmod 555 -R /app
