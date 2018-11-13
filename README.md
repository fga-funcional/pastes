# Pastes

A functional project to easily share code

## Frontend

```shell
elm make src/key.elm --output main.js && rm src/main.js && mv main.js src/ | python3 -m http.server
```

## Backend

```shell
curl -sSL https://get.haskellstack.org/ | sh

stack ghci
```

In ghci, run:

```shell
main
```

To update after any file is changed:

```shell
:r [nome].hs
```

