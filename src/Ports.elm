port module Ports exposing (networkStatus, saveValue)


port networkStatus : (String -> msg) -> Sub msg


port saveValue : String -> Cmd msg
