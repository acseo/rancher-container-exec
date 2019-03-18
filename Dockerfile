FROM        debian:jessie-slim
MAINTAINER  ACSEO <contact@acseo.fr>

#
# Create app dir and copy container_exec into it
#
RUN     mkdir -p /app
COPY    container-exec.sh /app/container-exec
RUN     chmod uog+x /app/container-exec

#
# Install utils
#
RUN     apt-get update && \
        apt-get install -yy curl jq && \
        rm -rf /var/lib/apt/lists/*
#
# Instlal wsta
#
RUN     cd /app && curl -SL https://github.com/esphen/wsta/releases/download/0.5.0/wsta-0.5.0-x86_64-unknown-linux-gnu.tar.gz | tar xvz && \
        mv wsta /usr/local/bin && \
        chmod u+x /usr/local/bin/wsta

#
# Final image configuration
#
VOLUME      /app
WORKDIR     /app
