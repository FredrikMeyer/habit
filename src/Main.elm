module Main exposing (init, main, update, view)

import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import Model exposing (Color(..), Counter, Model, Msg(..), NetworkStatus(..))
import Ports
import View



---- MODEL ----


type alias Flags =
    { startingValue : Maybe Int
    , counters : List Counter
    , isOnline : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        val =
            flags.startingValue
                |> Maybe.withDefault 0

        networkStatus =
            if flags.isOnline then
                Online

            else
                Offline

        initDict =
            flags.counters
                |> List.map (\c -> ( c.id, c ))
                |> Dict.fromList
    in
    ( { circleColor = Black
      , counters = Just initDict
      , networkStatus = networkStatus
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedCircle id ->
            case model.counters of
                Nothing ->
                    ( model, Cmd.none )

                Just dict ->
                    let
                        currentColor =
                            model.circleColor

                        nuTimes =
                            Dict.get
                                id
                                dict
                                |> Maybe.map .numberOfTimes
                                |> Maybe.map (\i -> i + 1)
                                |> Maybe.withDefault 0

                        updatedDictionary =
                            Dict.update
                                id
                                (Maybe.map
                                    (\v -> { v | numberOfTimes = nuTimes })
                                )
                                dict

                        cmd =
                            Dict.get id updatedDictionary
                                |> Maybe.map Ports.saveValue
                                |> Maybe.withDefault Cmd.none
                    in
                    case currentColor of
                        Black ->
                            ( { model
                                | circleColor = Red
                                , counters = Just updatedDictionary
                              }
                            , Cmd.batch [ cmd ]
                            )

                        Red ->
                            ( { model
                                | circleColor = Black
                                , counters = Just updatedDictionary
                              }
                            , Cmd.batch [ cmd ]
                            )

        ClickedPlus ->
            ( model, Cmd.none )

        NetworkMessage s ->
            case s of
                "online" ->
                    ( { model | networkStatus = Online }, Cmd.none )

                "offline" ->
                    ( { model | networkStatus = Offline }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    View.mainView model



---- PROGRAM ----


main : Program Flags Model Msg
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
