FROM debian:bullseye-slim as base

from base as build
# Update everything and install build dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install curl golang git -y
# Install Hugo
ENV HUGO_VERSION="0.81.0" \
    HUGO_PATH="/usr"
COPY install-hugo-from-gh.sh .
RUN ./install-hugo-from-gh.sh
# Add user for running hugo
RUN useradd -ms /bin/bash hugo

FROM build as prod
USER hugo
EXPOSE 1316
WORKDIR /home/hugo
COPY --chown=hugo:hugo . .

ENTRYPOINT ["./view-prod.sh"]
