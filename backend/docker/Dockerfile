FROM debian:latest

# Install dependencies.
RUN apt-get update && \
  apt-get install --assume-yes curl gcc libgmp-dev libpq-dev make xz-utils zlib1g-dev

# Install Stack.
RUN curl --location https://www.stackage.org/stack/linux-x86_64-static > stack.tar.gz && \
  tar xf stack.tar.gz && \
  cp stack-*-linux-x86_64-static/stack /usr/local/bin/stack && \
  rm -f -r stack.tar.gz stack-*-linux-x86_64-static/stack && \
  stack --version

WORKDIR /home/pastes-api
COPY stack.yaml /home/pastes-api/
COPY pastes-api.cabal /home/pastes-api/

RUN stack setup

COPY Main.hs home/pastes-api/

RUN stack --no-system-ghc --install-ghc build --allow-different-user

COPY postgresql/ /home/pastes-api/postgresql

RUN stack install
