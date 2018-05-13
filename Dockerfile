FROM debian:latest
MAINTAINER Kellman
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends locales bash-completion jq curl vim \
    tmux gnupg2 ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8 TERM=screen-256color
ENV NPM_CONFIG_LOGLEVEL info
RUN mkdir -p /doc && useradd -d /doc -s /bin/bash -u 501 doc && \
    mkdir -p /node && chown -R doc /node && chown -R doc /doc
# Install Utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends procps curl wget git build-essential \
    software-properties-common chrpath libssl-dev libxft-dev bzip2 openssh-client \
    python-pip python-setuptools python-dev && \
#    pip install --upgrade pip && \
    pip install --upgrade virtualenv && \
    pip install awscli && \
    apt-get install -y libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    mkdir -p /usr/lib/node_modules && ln -s /usr/lib/node_modules /usr/local/lib && \
    ln -s /usr/bin/nodejs /usr/local/bin/node && \
    npm i -g npm
## Install OpenJDK
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jre-headless && \
    rm -rf /var/lib/apt/lists/*
## Install Calibre
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends calibre fonts-noto fonts-noto-cjk locales-all && \
    rm -rf /var/lib/apt/lists/*
## Install Graphviz for PlantUML
RUN apt-get update && \
    apt-get install -y --no-install-recommends graphviz && \
    rm -rf /var/lib/apt/lists/*
COPY post-book /usr/local/bin/
EXPOSE 4000
VOLUME ["/doc"]
USER doc
ENV NPM_CONFIG_PREFIX=/node
RUN npm install -g phantomjs@2.1.1 --upgrade --unsafe-perm && \
    npm install -g node-plantuml && \
    npm install -g generate-schema && \
    npm install -g svgexport && \
## Install Gitbook
    npm install -g gitbook-cli && \
    npm install -g gitbook-summary
ENV PATH=/node/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin TERM=screen-256color
WORKDIR /doc
CMD ["/bin/bash", "-l"]
