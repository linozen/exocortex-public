# Hugo
FROM klakegg/hugo:0.101.0-ext-debian-onbuild AS hugo
# Caddy
FROM pierrezemb/gostatic
COPY --from=hugo /target/ /srv/http/
