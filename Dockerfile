FROM node:7.7.3

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive"

ENV REMOTE_MACHINE_IP="0.0.0.0" \
    REMOTE_USERNAME="" \
    REMOTE_PASSWORD=""

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get clean

#install locales-all below to stop the crap further down throwing errors
RUN apt-get install -y etherwake locales locales-all python3 && \
    curl https://bootstrap.pypa.io/get-pip.py | python3 && \
    python3 -m pip install pywinrm

# installing powershell below but not used as it currently doesn't work with existing remote windows powershell
# someone decided a dirty hack/kluge is the best option to use instead of doing it properly in
# the main reason to use powershell on linux, tl;dr WTF??!!
# see https://github.com/PowerShell/PowerShell/tree/master/demos/SSHRemoting
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

ADD src/entrypoint.sh /entrypoint
RUN chmod 0555 /entrypoint

WORKDIR /app
ADD src/server.js ./
ADD src/open_winrm.py ./
RUN npm init -y && \
    mkdir /usr/share/ca-certificates/remote-ps/ && \
    chmod 0755 /usr/share/ca-certificates/remote-ps/ && \
    chmod 0555 open_winrm.py server.js

VOLUME ["/var/log"]

EXPOSE 9000
CMD /entrypoint
