FROM node:10.16.0

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    DEBIAN_FRONTEND="noninteractive"

ENV LISTEN_IP="127.0.0.1" \
    LISTEN_PORT="9000" \
    WOL_MAC="" \
    WINRM_USERNAME="administrator" \
    WINRM_PASSWORD="xxxx" \
    WINRM_ENDPOINT="https://127.0.0.1:5986/wsman" \
    SSH_ENDPOINT="127.0.0.1" \
    SSH_USERNAME="ubuntu" \
    SSH_PASSWORD="xxxx" \
    USE_SSL="1" \
    SSL_PEER_FINGERPRINT="xxxx" \
    WOL_BROADCAST_ADDR="255.255.255.255"

RUN apt update && \
    apt -y upgrade && \
    apt -y autoremove && \
    apt clean

#install locales-all below to stop the crap further down throwing errors
RUN apt install -y etherwake locales locales-all ruby-full pm-utils && \
    gem install -r winrm net-ssh
    
##################### POWERSHELL #####################      
#https://docs.microsoft.com/en-gb/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-6#installation---raspbian

#Install prerequisites
RUN apt install -y libunwind8

#Grab the latest tar.gz
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v6.2.1/powershell-6.2.1-linux-arm64.tar.gz
# Make folder to put powershell
RUN mkdir ~/powershell
# Unpack the tar.gz file
RUN tar -xvf ./powershell-6.2.1-linux-arm64.tar.gz -C ~/powershell
# create a symbolic link to start PowerShell just calling "pwsh"
RUN ln -s ~/powershell/pwsh /usr/bin/pwsh

##################### END POWERSHELL #####################    

RUN rm -rf /var/lib/apt/lists/*

ADD src/entrypoint.sh /entrypoint
RUN chmod 0555 /entrypoint

WORKDIR /app
ADD src/server.js ./
ADD src/open_winrm.rb ./
ADD src/send_wol.sh ./
ADD src/open_ssh.rb ./
RUN node -v
RUN npm -v
RUN npm init -y && \
    chmod 0555 open_winrm.rb server.js send_wol.sh open_ssh.rb

VOLUME ["/var/log"]

EXPOSE 9000
CMD /entrypoint
