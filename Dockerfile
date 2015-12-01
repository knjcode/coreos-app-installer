FROM golang

# Create app dir
RUN mkdir /app

# Make direnv
RUN go get github.com/direnv/direnv \
  && cd /go/src/github.com/direnv/direnv \
  && git checkout v2.7.0 \
  && make \
  && mv direnv /app

# Make fugu
RUN go get github.com/tools/godep \
  && git clone --depth 1 https://github.com/mattes/fugu /go/src/github.com/mattes/fugu \
  && cd /go/src/github.com/mattes/fugu/fugu \
  && GOOS=linux GOARCH=amd64 godep go build -o /app/fugu

# Download cf 6.14.0
ENV CF_VERSION 6.14.0
RUN curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&version=$CF_VERSION" > /app/cf.tgz

# Download docker-compose 1.5.1
ENV DOCKER_COMPOSE_VERSION 1.5.1
RUN curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 > /app/docker-compose \
  && chmod +x /app/docker-compose

# install unzip
RUN apt-get update && apt-get install -y unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Download docker-machine 0.5.2
ENV DOCKER_MACHINE_VERSION 0.5.2
RUN curl -L https://github.com/docker/machine/releases/download/v$DOCKER_MACHINE_VERSION/docker-machine_linux-amd64.zip > /app/machine.zip \
  && cd /app \
  && unzip machine.zip \
  && rm machine.zip

# apt-get bash-completions (with docker and docker-compose)
RUN apt-get update && apt-get install -y bash-completion \
  && rm -rf /var/lib/apt/lists/* \ 
  && wget https://raw.githubusercontent.com/docker/docker/master/contrib/completion/bash/docker -O /usr/share/bash-completion/completions/docker \
  && wget https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -O /usr/share/bash-completion/completions/docker-compose

ADD installer /installer

RUN chmod +x /installer

CMD /installer
