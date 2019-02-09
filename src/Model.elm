module Model exposing (Color(..), Model, Msg(..), NetworkStatus(..), networkStatusAsString)


type alias Model =
    { circleColor : Color
    , numberOfTimes : Int
    , networkStatus : Maybe NetworkStatus
    }


type Color
    = Black
    | Red


type NetworkStatus
    = Online
    | Offline


networkStatusAsString : Maybe NetworkStatus -> String
networkStatusAsString networkStatus =
    case networkStatus of
        Just Online ->
            "online"

        Just Offline ->
            "offline"

        Nothing ->
            "dont know yet"


type Msg
    = NoOp
    | ClickedCircle
    | NetworkMessage String
