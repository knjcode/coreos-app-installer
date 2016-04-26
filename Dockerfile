FROM golang:1.5.3

# Create app dir
RUN mkdir /app

# install unzip jq bash-completion
RUN apt-get update && apt-get install -y unzip jq bash-completion \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Download bash-completions
RUN wget https://raw.githubusercontent.com/docker/docker/master/contrib/completion/bash/docker -O /usr/share/bash-completion/completions/docker \
  && wget https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -O /usr/share/bash-completion/completions/docker-compose \
  && wget https://raw.githubusercontent.com/tokubass/ghq-bash-completion/master/.ghq-completion.bash -O /usr/share/bash-completion/completions/ghq

# Make fugu
RUN go get github.com/tools/godep \
  && git clone --depth 1 https://github.com/mattes/fugu /go/src/github.com/mattes/fugu \
  && cd /go/src/github.com/mattes/fugu/fugu \
  && GOOS=linux GOARCH=amd64 godep go build -o /app/fugu

# Make direnv
RUN go get github.com/direnv/direnv \
  && cd /go/src/github.com/direnv/direnv \
  && git checkout v2.7.0 \
  && make \
  && mv direnv /app

# Download cf 6.17.0
ENV CF_VERSION 6.17.0
RUN curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&version=$CF_VERSION" > /app/cf.tgz

# Download docker-compose 1.7.0
ENV DOCKER_COMPOSE_VERSION 1.7.0
RUN curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 > /app/docker-compose \
  && chmod +x /app/docker-compose

# Download docker-machine 0.7.0
ENV DOCKER_MACHINE_VERSION 0.7.0
RUN curl -L https://github.com/docker/machine/releases/download/v$DOCKER_MACHINE_VERSION/docker-machine-linux-x86_64 > /app/docker-machine \
  && chmod +x /app/docker-machine

# Make ghq
RUN go get github.com/motemen/ghq \
  && cd /go/src/github.com/motemen/ghq \
  && make \
  && mv ghq /app

# Make peco
RUN go get github.com/peco/peco \
  && cd /go/src/github.com/peco/peco \
  && go build cmd/peco/peco.go \
  && mv peco /app

ADD installer /installer

RUN chmod +x /installer

CMD /installer
