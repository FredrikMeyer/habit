port module Ports exposing (networkStatus, saveValue)

import Model exposing (Counter)


port networkStatus : (String -> msg) -> Sub msg


port saveValue : Counter -> Cmd msg
