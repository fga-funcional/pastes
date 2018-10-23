module App exposing (init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox
        { view = view
        , update = update
        , init = init
        }



-- MODEL --------------------------------------------------


type alias Model =
    { codes : List String, current : String }


init : Model
init =
    { codes = [], current = "" }



-- MESSAGES ----------------------------------------------


type Msg
    = Clear
    | Add
    | Current String


update : Msg -> Model -> Model
update msg m =
    case msg of
        Clear ->
            { m | current = "" }

        Add ->
            { codes = m.current :: m.codes
            , current = ""
            }

        Current st ->
            { m | current = st }



-- VIEW --------------------------------------------------


view : Model -> Html Msg
view m =
    div []
        [ h1 [] [ text "Pêistebin" ]
        , textarea [ placeholder "Escreva seu código aqui", onInput Current, rows 20, cols 100 ] []
        , inputElem m
        , button [] [ text "Criar pêiste" ]
        ]


inputElem m =
    input
        [ placeholder "Nome do pêiste"
        , onInput Current
        , value m.current
        ]
        []
