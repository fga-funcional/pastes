module View exposing (view)

import Array
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Json
import Model exposing (..)
import Msg exposing (Msg(..))


view model =
    div []
        [ textarea [ onKeyDown KeyDown, onInput Input, value model.currentText, class "text-editor" ] []
        , inputElem model
        , button [ onClick Add ] [ text "Add" ]
        , showCodes model.savedCodes
        ]


showCodes : Array.Array Code -> Html Msg
showCodes codes =
    ul [] (Array.toList (Array.indexedMap showCode codes))


showCode : Int -> Code -> Html Msg
showCode idx code =
    div []
        [ h3 [] [ text code.codename ]
        , li [] (List.map (\l -> li [] [ text l ]) code.lines)
        ]


renderList lst =
    ul []
        (List.map (\l -> li [] [ text l ]) lst)


inputElem m =
    input
        [ placeholder "Nome do pêiste"
        , onInput InputName
        , value m.name
        ]
        []


showTodos m =
    ul [] (List.map showTodo m)


showTodo st =
    li [] [ text st ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)
