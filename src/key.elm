import Html exposing (..)
import Http exposing (..)
import Browser
import Html.Attributes exposing (attribute, class, value)

import Html.Events exposing (..)
import Json.Decode as Json
import Json.Decode exposing (string, list, decodeString, Decoder)



main =
  Browser.element
  { init= init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : () -> ( Model, Cmd Msg )
init _ =
    ( { codes= []
      , savedText = "" 
      , currentText = "" 
      }
    , Cmd.none
    )
type alias Model =
    { codes: List String
    , savedText: String
    , currentText: String
    }

view model =
    div []
        [ textarea [ onKeyDown KeyDown, onInput Input, value model.currentText, class "text-editor" ] []
        , button [ onClick Add ] [ text "Add" ]
        , renderList model.codes
        , button [ onClick SendHttpRequest ]
            [ text "Get data from server" ]
        

        ]

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
  | Add
  | SendHttpRequest
  | DataReceived (Result Http.Error (List String))

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

    Add ->
        ({ model | codes = model.codes ++   (String.split "\n" model.currentText), currentText = ""
        }, Cmd.none)

    SendHttpRequest ->
        ( model, httpCommand )

    DataReceived (Ok codes) ->
        ( {model | codes = codes}, Cmd.none )

    DataReceived (Err httpError) ->
            ( { model
                | savedText = "erro" 
              }
            , Cmd.none
            )




codesDecoder : Decoder (List String)
codesDecoder =
    list string

httpCommand : Cmd Msg
httpCommand =
    codesDecoder
        |> Http.get "http://localhost:3000/codes"
        |> Http.send DataReceived

