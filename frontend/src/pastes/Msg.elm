module Msg exposing (..)

import Model exposing (..)

import Http exposing (..)
import Array
import Json.Decode as Json
import Html.Attributes exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

setCodeName : String -> Code -> Code
setCodeName newName code = 
  { code | codename = newName}

setCodeSyntax : String -> Code -> Code
setCodeSyntax newSyntax code = 
  { code | syntax = newSyntax }
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

type Msg 
  = NoOp
  | KeyDown Int 
  | Input String
  | InputName String
  | InputCode String
  | Add 
  | GetSavedCodes (Result Http.Error (Array.Array Code))

validate : (Model, Cmd Msg) -> (Model, Cmd Msg)
validate (model, cmd) = 
    let
        codeStatus =
            if model.currentText == "" then
                EmptyCode
            else
                ValidCode 
    
        nameStatus =
            if model.name == "" then
                EmptyName
            else if String.length model.name < 5 then
                ShortName 
            else
                ValidName
        ready =
            (codeStatus == ValidCode)
                && (nameStatus == ValidName)
    in
        ({ model
            | codeValidation = codeStatus
            , nameValidation = nameStatus 
        }, Cmd.none)

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
      validate ({ model | currentText = text}, Cmd.none)

    InputName text ->
      validate ({ model | name = text , savedText = text}, Cmd.none)

    InputCode text ->
      validate ({ model | currentSyntax = text }, Cmd.none)

    Add ->
          let
              newModel =
                  model.currentCode
                      |> setCodeSyntax model.currentSyntax
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
        Json.map3 Code
            (Json.field "codename" Json.string)
            (Json.field "lines" (Json.list Json.string))
            (Json.field "syntax" Json.string)
    )


codesDecoder : Json.Decoder (List String)
codesDecoder =
    Json.list Json.string
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

init : () -> (Model, Cmd Msg) 
init _ = (Model.init, Http.send GetSavedCodes getCodes) 
