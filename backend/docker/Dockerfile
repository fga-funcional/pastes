FROM haskell

ADD ./ /pastebin_api

WORKDIR /pastebin_api

RUN stack ghci --install-ghc

CMD ./backend/docker/entrypoint.sh
