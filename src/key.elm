import Html exposing (..)
import Http exposing (..)
import Browser
import Html.Attributes exposing (..)
import Array

import Html.Events exposing (..)
import Json.Decode as Json
import Json.Decode exposing (string, list, decodeString, Decoder)



main =
  Browser.element { init= init , view = view , update = update , subscriptions = subscriptions }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

type alias Code = 
  {codename: String,
   lines: List String
  }

type alias Model =
    { savedCodes: Array.Array Code 
    , newCode: List String
    , name: String
    , savedText: String
    , currentText: String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Array.fromList []) [] "" "" "" 
    , Http.send  GetSavedCodes getCodes
    )

view model =
    div []
        [ textarea [ onKeyDown KeyDown, onInput Input, value model.currentText, class "text-editor" ] []
        , inputElem model
        , button [ onClick Add ] [ text "Add" ]
        , showCodes model.savedCodes
        ]

showCodes : Array.Array Code-> Html Msg
showCodes codes =
    ul [] (Array.toList (Array.indexedMap showCode codes))


showCode : Int -> Code-> Html Msg
showCode idx code=
        div[][
        h3[][text code.codename]
        ,li[] (List.map (\l -> li [] [ text l ]) code.lines)]

renderList lst =
    ul []
        (List.map (\l -> li [] [ text l ]) lst)

showTodos m =
    ul [] (List.map showTodo m)

showTodo st =
    li [] [ text st ]

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.map tagger keyCode)

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
        ({ model | newCode = model.name ::   (String.split "\n" model.currentText), currentText = ""
        }, Cmd.none)


        {-
    SendHttpRequest ->
        ( model, httpCommand )
    DataReceived (Ok savedCodes) ->
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
