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
import SyntaxHighlight exposing (..)



view model =
    div []
        [ h1[][text "Pêistebim" ]
        , textarea [ onKeyDown KeyDown, onInput Input, value model.currentText, class "text-editor" ] []
        , inputElem model
        , button [ onClick Msg.Add ] [ text "Add" ]
        , showCodes model.savedCodes
        ]


showCodes : Array.Array Code -> Html Msg
showCodes codes =
    ul [] (Array.toList (Array.indexedMap showCode codes))


showCode : Int -> Code -> Html Msg
showCode idx codex =
  div []
        [  h3[][text codex.codename]
        , useTheme oneDark 
        , elm (String.join "\n" codex.lines) 
            |> Result.map (toBlockHtml (Just 1))
            |> Result.withDefault
                (pre [] [ code [] [ text (String.join "\n" codex.lines)]])
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
