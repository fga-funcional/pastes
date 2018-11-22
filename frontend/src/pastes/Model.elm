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


init : Model
init =
    ( Model (Array.fromList []) {codename="", lines=[]} "" "" "")
