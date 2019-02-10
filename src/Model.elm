module Model exposing (Color(..), Counter, Model, Msg(..), NetworkStatus(..), networkStatusAsString)

import Dict exposing (Dict)


type alias Model =
    { circleColor : Color
    , counters : Dict Int Counter
    , networkStatus : NetworkStatus
    , nameOfNewCounter : Maybe String
    }


type alias Counter =
    { name : String
    , numberOfTimes : Int
    , id : Int
    }


type Color
    = Black
    | Red


type NetworkStatus
    = Online
    | Offline


networkStatusAsString : NetworkStatus -> String
networkStatusAsString networkStatus =
    case networkStatus of
        Online ->
            "online"

        Offline ->
            "offline"


type Msg
    = NoOp
    | ClickedCircle Int
    | ClickedPlus
    | NetworkMessage String
    | NewCounterMessage String
    | SubmitNewCounter
