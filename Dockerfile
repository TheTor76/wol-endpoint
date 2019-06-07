FROM ubuntu:18.04

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive"

ENV LISTEN_IP="127.0.0.1" \
    LISTEN_PORT="9000" \
    WOL_MAC="" \
    WINRM_USERNAME="administrator" \
    WINRM_PASSWORD="xxxx" \
    WINRM_ENDPOINT="https://127.0.0.1:5986/wsman" \
    USE_SSL="1" \
    SSL_PEER_FINGERPRINT="xxxx" \
    WOL_BROADCAST_ADDR="255.255.255.255"

WORKDIR /]
RUN apt update && apt -y upgrade

#install locales-all below to stop the crap further down throwing errors
RUN apt install -y etherwake locales locales-all ruby-full ruby-dev gcc libffi-dev make
RUN gem update --system
RUN gem install -r winrm
RUN rm -rf /var/lib/apt/lists/*

ADD src/entrypoint.sh /entrypoint
RUN chmod 0555 /entrypoint

WORKDIR /app
ADD src/server.js ./
ADD src/open_winrm.rb ./
ADD src/send_wol.sh ./
RUN apt-get update && apt-get install -y apt-transport-https
RUN apt install -y npm
RUN npm init -y && \
    chmod 0555 open_winrm.rb server.js send_wol.sh

VOLUME ["/var/log"]

EXPOSE "$LISTEN_PORT"
CMD /entrypoint
