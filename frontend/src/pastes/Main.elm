-- Main.elm
module Main exposing (main)

import Model exposing (..)
import View exposing (..)
import Msg exposing (..)

import Json.Decode as Json
import Json.Decode exposing (string, list, decodeString, Decoder)



main =
  Browser.element { init= init , view = view , update = update , subscriptions = subscriptions }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

setCodeName : String -> Code -> Code
setCodeName newName code = 
  { code | codename = newName}

setCodeLines : List String -> Code -> Code
setCodeLines newLines code = 
  { code | lines = newLines}

setCurrentCode: Code -> Model -> Model
setCurrentCode newCode model =
    { model | currentCode = newCode}

flip : (a -> b -> c) -> b -> a -> c
flip f b a =
  f a b

asCurrentCodeIn : Model -> Code -> Model
asCurrentCodeIn =
    flip setCurrentCode
