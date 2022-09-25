# Hugo
FROM klakegg/hugo:0.101.0-ext-debian-onbuild AS hugo
# GoStatic
# FROM pierrezemb/gostatic
# COPY --from=hugo /target/ /srv/http/

# Caddy
FROM caddy:2
COPY --from=hugo /target/ /usr/share/caddy/
COPY ./Caddyfile /etc/caddy/Caddyfile
