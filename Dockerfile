FROM node:7.7.3

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get clean

RUN apt-get install -y etherwake locales locales-all #install locales-all to stop the crap below erroring

#####################
# START COPY from official powershell dockerfile @ https://github.com/PowerShell/PowerShell
#####################

# Setup the locale #not really sure why care about lang, etc but ok???
ENV LANG="en_GB.UTF-8"
ENV LANGUAGE="$LANG" \
    LC_TYPE="$LANG" \
    LC_ALL="$LANG"

RUN locale-gen $LANG && update-locale && dpkg-reconfigure locales #one of these is bound to work :/

RUN apt-get install -y --no-install-recommends \
        apt-utils \
        ca-certificates \
        curl \
        apt-transport-https

# Import the public repository GPG keys for Microsoft
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Register the Microsoft Ubuntu 14.04 repository
RUN curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list

# Install powershell from Microsoft Repo
RUN apt-get update && \
    apt-get install -y --no-install-recommends powershell

##################### END COPY #####################

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN npm init -y && npm install hs100-api
ADD src/server.js ./

VOLUME ["/var/log"]

ENV PC_IP="192.168.86.16"

EXPOSE 9000
CMD /usr/local/bin/node server.js
