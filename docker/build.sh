#!/bin/sh

set -xe

# Create wh user for webhook
addgroup -S wh
adduser -G wh -H -D -g 'webhook wh user' wh -s /sbin/nologin && usermod -p '*' wh

# Create default hooks.json
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
