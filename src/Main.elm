module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Svg exposing (Svg)
import Svg.Attributes



---- MODEL ----


type alias Model =
    { circleColor : Color
    }


init : ( Model, Cmd Msg )
init =
    ( { circleColor = Black
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedCircle ->
            let
                currentColor =
                    model.circleColor
            in
            case currentColor of
                Black ->
                    ( { model | circleColor = Red }, Cmd.none )

                Red ->
                    ( { model | circleColor = Black }, Cmd.none )

        _ ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Habit Tracker" ]
        , Svg.svg [ Svg.Attributes.width "100", Svg.Attributes.height "100", Svg.Attributes.viewBox "0 0 100 100" ]
            [ circle model.circleColor ]
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


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
