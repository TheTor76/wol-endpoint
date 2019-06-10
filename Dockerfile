FROM node:10.16.0

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

RUN apt update && \
    apt -y upgrade && \
    apt -y autoremove && \
    apt clean

#install locales-all below to stop the crap further down throwing errors
RUN apt install -y etherwake locales locales-all ruby-full && \
    gem install -r winrm
    
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

RUN apt install -y --no-install-recommends \
        apt-utils \
        ca-certificates \
        apt-transport-https \
        software-properties-common
        
# Download the Microsoft repository GPG keys
#wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN wget -q https://github.com/PowerShell/PowerShell/releases/download/v6.2.1/powershell_6.2.1-1.ubuntu.18.04_amd64.deb
# Register the Microsoft repository GPG keys
#dpkg -i packages-microsoft-prod.deb
RUN dpkg -i powershell_6.2.0-1.ubuntu.18.04_amd64.deb && apt install -f

# Update the list of products
#apt update

# Enable the "universe" repositories
#add-apt-repository universe

# Install PowerShell
#apt install -y powershell     

# Import the public repository GPG keys for Microsoft
#RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Register the Microsoft Ubuntu 14.04 repository
#RUN curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list

# Install powershell from Microsoft Repo
#RUN apt-get update && \
    #apt-get install -y --no-install-recommends powershell

##################### END COPY #####################    

RUN rm -rf /var/lib/apt/lists/*

ADD src/entrypoint.sh /entrypoint
RUN chmod 0555 /entrypoint

WORKDIR /app
ADD src/server.js ./
ADD src/open_winrm.rb ./
ADD src/send_wol.sh ./
RUN node -v
RUN npm -v
RUN npm init -y && \
    chmod 0555 open_winrm.rb server.js send_wol.sh

VOLUME ["/var/log"]

EXPOSE 9000
CMD /entrypoint
