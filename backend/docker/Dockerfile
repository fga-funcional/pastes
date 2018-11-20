FROM haskell

ADD ./pastebin.cabal /pastebin_api/pastebin.cabal

ADD ./stack.yaml /pastebin_api/stack.yaml

WORKDIR /pastebin_api

RUN stack ghci --install-ghc

ADD ./Main.hs /pastebin_api/Main.hs

RUN ls

CMD ./backend/docker/entrypoint.sh
