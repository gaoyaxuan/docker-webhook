#!/bin/sh

set -xe

# Install gosu
if [ "$(uname -m)" = "aarch64" ]; then
  export arch='arm64'
  export checksum='c3805a85d17f4454c23d7059bcb97e1ec1af272b90126e79ed002342de08389b'
elif [ "$(uname -m)" = "armv7l" ]; then
  export arch='armhf'
  export checksum='e5866286277ff2a2159fb9196fea13e0a59d3f1091ea46ddb985160b94b6841b'
else
  export arch='amd64'
  export checksum='bbc4136d03ab138b1ad66fa4fc051bafc6cc7ffae632b069a53657279a450de3'
fi

wget --quiet https://github.com/tianon/gosu/releases/download/1.17/gosu-${arch} -O /usr/sbin/gosu
echo "${checksum}  /usr/sbin/gosu" | sha256sum -cs
chmod +x /usr/sbin/gosu


# Create wh user for webhook
addgroup -S wh
adduser -G wh -H -D -g 'webhook wh user' wh  -s /sbin/nologin && usermod -p '*' wh

chown root:root -R  /app
chmod 555 -R /app

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
