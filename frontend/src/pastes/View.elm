module  View exposing  (view)

import Model exposing (..)

import Html exposing (..)
import Http exposing (..)
import Browser
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Array

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
