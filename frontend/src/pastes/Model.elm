module Model exposing (Code, Model, init)

import Array

import Http exposing (..)

type alias Code =
  {codename: String,
   lines: List String
  }


type alias Model =
    { savedCodes: Array.Array Code
    , currentCode: Code
    , name: String
    , savedText: String
    , currentText: String
    }


init : () -> ( Model, Cmd msg )
init _ =
    ( Model (Array.fromList []) {codename="", lines=[]} "" "" ""
    , Http.send  GetSavedCodes getCodes
    )
