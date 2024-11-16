[Webhook](https://github.com/adnanh/webhook/) Dockerized
=================

```shell  
services:
  webhook:
    image: ghcr.io/gaoyaxuan/webhook:latest
    container_name: webhook
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    networks:
      - webhook_network
    volumes:
      - ./config/hooks.json:/app/hooks.json:ro
    ports:
      - 127.0.0.1:9000:9000
    #command: ["-hooks","/app/webhook/hooks.json","-ip","0.0.0.0","-port","9000","-tls-min-version","1.2","-verbose"]


networks:
  webhook_network:
    driver: bridge
```
