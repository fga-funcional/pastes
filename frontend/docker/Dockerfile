FROM debian:buster-slim

RUN apt-get update -q && apt-get install -q -y \
        curl apt-transport-https apt-utils dialog \
        gnupg

RUN curl -sSO https://deb.nodesource.com/gpgkey/nodesource.gpg.key
RUN apt-key add nodesource.gpg.key
RUN echo "deb https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" >> /etc/apt/sources.list.d/nodesource.list
RUN apt-get update -q && apt-get install -y 'nodejs=9.11.1' && npm i -g npm

RUN npm --version

RUN npm install -g elm@0.19.0-bugfix2

CMD sleep infinity
