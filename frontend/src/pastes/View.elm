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


import Bulma.CDN exposing (..)
import Bulma.Modifiers exposing (..)
import Bulma.Modifiers.Typography exposing (textCentered)
import Bulma.Form exposing (..)
import Bulma.Elements exposing (..)
import Bulma.Components exposing (..)
import Bulma.Columns as Columns exposing (..)
import Bulma.Layout exposing (..)

fontAwesomeCDN
  = Html.node "link"
    [ rel "stylesheet"
    , href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
    ]
    []

exampleHero : Html Msg
exampleHero
  = hero { heroModifiers | color = Info, size = Small} []
    [ heroBody []
      [ container []
        [ Bulma.Elements.title H3 [] [ text "Pêistebim" ]
        ]
      ]
    ]

nameError status =
    case status of
        ValidName ->
           div[][]
        ShortName ->
          notification Warning []
            [ text "Tá de murrinhagem de caracteres é?"
            ]
        EmptyName ->
          notification Danger []
            [ text "O código deve ter um nome!"
            ]

codeError status =
    case status of
        ValidCode ->
           div[][]
        EmptyCode ->
          notification Warning []
            [ text "Coda aí vai"
            ]

view model =
    div[][
    exampleHero
    ,container []
        [ stylesheet
        , fontAwesomeCDN
        , Html.form[] [
          codeField model
        , nameField model
        , field []
            [ controlButton { buttonModifiers | color = Link } [] [onClick Msg.Add]
              [ text "Adicionar"]
              ]
        , showCodes model.savedCodes
        ]
        ]
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

codeField m = 
    field []
            [ controlLabel [] [ text "Código" , codeError m.codeValidation], controlTextArea controlTextAreaModifiers [] [ placeholder "Insira o código",class "text-editor", onInput Input, value m.currentText] []
            ]

nameField m =
    field []
            [ controlLabel [] [ text "Nome" , nameError m.nameValidation]
            , controlInput controlInputModifiers [] [ placeholder "Nome do pêiste", value m.name, onInput InputName ] [nameError m.nameValidation ] 
            , controlHelp Default [] [ text "Esse campo é obrigarório!" ]
            ]



showTodos m =
    ul [] (List.map showTodo m)


showTodo st =
    li [] [ text st ]


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)
