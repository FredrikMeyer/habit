module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, b, div, h1, img, text)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Ports
import Svg exposing (Svg)
import Svg.Attributes



---- MODEL ----


type alias Model =
    { circleColor : Color
    , numberOfTimes : Int
    , networkStatus : Maybe NetworkStatus
    }


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


type Color
    = Black
    | Red



---- UPDATE ----


type Msg
    = NoOp
    | ClickedCircle
    | NetworkMessage String


type NetworkStatus
    = Online
    | Offline


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
                    Debug.log "!"
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
    let
        networkString =
            case model.networkStatus of
                Just Online ->
                    "online"

                Just Offline ->
                    "offline"

                Nothing ->
                    "dont know yet"
    in
    div []
        [ h1 [] [ text "Habit Tracker" ]
        , Svg.svg
            [ Svg.Attributes.width "100"
            , Svg.Attributes.height "100"
            , Svg.Attributes.viewBox "0 0 100 100"
            ]
            [ circle model.circleColor ]
        , div []
            [ b [] [ text <| "Antall ganger " ++ String.fromInt model.numberOfTimes ] ]
        , div []
            [ text <| networkString ]
        ]


circle : Color -> Svg Msg
circle color =
    let
        c =
            case color of
                Black ->
                    "black"

                Red ->
                    "red"
    in
    Svg.circle
        [ Svg.Attributes.cx "50"
        , Svg.Attributes.cy "50"
        , Svg.Attributes.r "40"
        , Svg.Attributes.fill c
        , onClick ClickedCircle
        ]
        []



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
