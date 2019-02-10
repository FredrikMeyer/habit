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
      , counters = initDict
      , networkStatus = networkStatus
      , nameOfNewCounter = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedCircle id ->
            let
                currentColor =
                    model.circleColor

                nuTimes =
                    Dict.get
                        id
                        model.counters
                        |> Maybe.map .numberOfTimes
                        |> Maybe.map (\i -> i + 1)
                        |> Maybe.withDefault 0

                updatedDictionary =
                    Dict.update
                        id
                        (Maybe.map
                            (\v -> { v | numberOfTimes = nuTimes })
                        )
                        model.counters

                cmd =
                    Dict.get id updatedDictionary
                        |> Maybe.map Ports.saveValue
                        |> Maybe.withDefault Cmd.none
            in
            case currentColor of
                Black ->
                    ( { model
                        | circleColor = Red
                        , counters = updatedDictionary
                      }
                    , Cmd.batch [ cmd ]
                    )

                Red ->
                    ( { model
                        | circleColor = Black
                        , counters = updatedDictionary
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

        NewCounterMessage name ->
            ( { model | nameOfNewCounter = Just name }, Cmd.none )

        SubmitNewCounter ->
            let
                newKey =
                    nextKey model.counters

                updatedDictionary =
                    Dict.insert newKey
                        { name = Maybe.withDefault "no-name" model.nameOfNewCounter
                        , numberOfTimes = 0
                        , id = newKey
                        }
                        model.counters
            in
            ( { model | counters = updatedDictionary }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


nextKey : Dict Int Counter -> Int
nextKey dict =
    dict
        |> Dict.keys
        |> List.sort
        |> List.head
        |> Maybe.map (\i -> i + 1)
        |> Maybe.withDefault 0



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
