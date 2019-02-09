module Main exposing (init, main, update, view)

import Browser
import Html exposing (Html)
import Model exposing (Color(..), Model, Msg(..), NetworkStatus(..))
import Ports
import View



---- MODEL ----


init : Maybe Int -> ( Model, Cmd Msg )
init startingVal =
    let
        val =
            Maybe.withDefault 0 startingVal
    in
    ( { circleColor = Black
      , numberOfTimes = val
      , networkStatus = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedCircle ->
            let
                currentColor =
                    model.circleColor

                nuTimes =
                    model.numberOfTimes + 1

                cmd =
                    Ports.saveValue <| String.fromInt nuTimes
            in
            case currentColor of
                Black ->
                    ( { model
                        | circleColor = Red
                        , numberOfTimes = nuTimes
                      }
                    , Cmd.batch [ cmd ]
                    )

                Red ->
                    ( { model
                        | circleColor = Black
                        , numberOfTimes = nuTimes
                      }
                    , Cmd.batch [ cmd ]
                    )

        NetworkMessage s ->
            case s of
                "online" ->
                    ( { model | networkStatus = Just Online }, Cmd.none )

                "offline" ->
                    ( { model | networkStatus = Just Offline }, Cmd.none )

                _ ->
                    ( { model | networkStatus = Nothing }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    View.mainView model



---- PROGRAM ----


main : Program (Maybe Int) Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.networkStatus NetworkMessage
        ]
