module Msg exposing (Msg(..), update)

import Model exposing (..)

import Http exposing (..)
import Array exposing (..)

type Msg 
  = NoOp
  | KeyDown Int 
  | Input String
  | InputName String
  | Add 
  --| SendHttpRequest
  | GetSavedCodes (Result Http.Error (Array.Array Code))
  --| DataReceived (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of

    NoOp ->
      (model, Cmd.none)

    KeyDown key ->
      if key == 13 then
        ({ model | savedText = model.savedText ++ "  "  }, Cmd.none)
      else
        (model, Cmd.none)

    Input text ->
      ({ model | currentText = text , savedText = text}, Cmd.none)

    InputName text ->
      ({ model | name = text , savedText = text}, Cmd.none)

    Add ->
          let
              newModel =
                  model.currentCode
                      |> setCodeName model.name
                      |> setCodeLines (String.split "\n" model.currentText)
                      |> asCurrentCodeIn model
          in
              ({model | savedCodes = Array.push newModel.currentCode model.savedCodes, currentText = "", name = ""}, Cmd.none)
        {-
        ({ model | newCode.name = name, newCode.lines = (String.split "\n" model.currentText), currentText = ""
        }, Cmd.none)


    SendHttpRequest ->
        ( model, httpCommand )
    DataReceived (Ok savedCodes) ->
        ( {model | savedCodes = savedCodes}, Cmd.none )

    DataReceived (Err httpError) ->
        ( {model | savedCodes = savedCodes}, Cmd.none )

    DataReceived (Err httpError) ->
            ( { model
                | savedText = "erro"
              }
            , Cmd.none
            )
            -}
    GetSavedCodes result ->
        case result of
            Err httpError ->
                ( model, Cmd.none )

            Ok codes->
                ( { model | savedCodes = codes }, Cmd.none )

inputElem m =
    input
        [ placeholder "Nome do pêiste"
        , onInput InputName
        , value m.name
        ]
        []

codeDecoder: Json.Decoder (Array.Array Code)
codeDecoder =
    Json.array (
        Json.map2 Code
            (Json.field "codename" Json.string)
            (Json.field "lines" (Json.list Json.string))
    )


codesDecoder : Decoder (List String)
codesDecoder =
    list string
{-
httpCommand : Cmd Msg
httpCommand =
    codesDecoder
        |> Http.get "http://localhost:3000/codes/factorial"
        |> Http.send DataReceived
-}
getCodes : Http.Request (Array.Array Code)
getCodes =
  Http.get "http://localhost:3000/codes" codeDecoder

