import Html exposing (..)
import Http exposing (..)
import Browser
import Html.Attributes exposing (..)
import Array

import Html.Events exposing (..)
import Json.Decode as Json
import Json.Encode as Encode exposing (..)
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



type alias Model =
    { savedCodes: Array.Array Code 
    , currentCode: Code 
    , name: String
    , savedText: String
    , currentText: String
    }

init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Array.fromList []) {codename="", lines=[]} "" "" "" 
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
  | CodeCreated (Result Http.Error Code)

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
              ({model | savedCodes = Array.push newModel.currentCode model.savedCodes, currentText = "", name = ""}, createCodeCommand model.currentCode)
        {-
        ({ model | newCode.name = name, newCode.lines = (String.split "\n" model.currentText), currentText = ""
        }, Cmd.none)


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

    CodeCreated (Ok code) ->
            ({ model | savedCodes = addNewCode code model.savedCodes, currentCode = Array.fromList [] 
              }, Cmd.none )
    CodeCreated (Err _) ->
      (model, Cmd.none)

addNewCode : Code -> (Array.Array Code) -> (Array.Array Code)
addNewCode newCode codes =
    let
        appendCode : (Array.Array Code) -> (Array.Array Code)
        appendCode listOfCodes =
            Array.append listOfCodes [ newCode]
    in
        Array.map appendCode codes 

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

createCodeCommand : Code -> Cmd Msg
createCodeCommand code =
  let
      url = "http://localhost:3000/codes/" 
      body = codeEncoder code
      request = Http.post url body string
  in
     Http.send CodeCreated request

codeEncoder : Code -> Http.Body 
codeEncoder code =
   Http.jsonBody
   <| Encode.object
        [ ( "codename", Encode.string code.codename)
        , ( "lines", (Encode.list Encode.string) code.lines)
        ]
createCodeRequest : Code -> Http.Request Code 
createCodeRequest code =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://localhost:3000/posts/" ++ code.codename
        , body = Http.jsonBody (codeEncoder code)
        , expect = Http.expectJson codeDecoder
        , timeout = Nothing
        , withCredentials = False
        }

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

