module Model exposing (..) 

import Array

import Http exposing (..)

type alias Code =
  {codename: String,
   lines: List String
  }


type alias Model =
    { savedCodes: Array.Array Code
    , currentCode: Code
    , codeValidation: CodeStatus
    , name: String
    , nameValidation: NameStatus
    , savedText: String
    , currentText: String
    }

type CodeStatus = EmptyCode | ValidCode 
type NameStatus = EmptyName | ShortName | ValidName 

 
init : Model
init =
    ( Model (Array.fromList []) {codename="", lines=[]} EmptyCode "" EmptyName "" "")
