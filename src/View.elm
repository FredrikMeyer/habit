module View exposing (mainView)

import Element exposing (Element, alignBottom, centerX, column, el, fill, height, padding, rgb255, row, text, width)
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (onClick)
import Model exposing (Color(..), Model, Msg(..), networkStatusAsString)
import Svg
import Svg.Attributes


mainView : Model -> Html Msg
mainView model =
    Element.layout
        [ Font.family
            [ Font.typeface "Source Sans Pro"
            , Font.typeface "Trebuchet MS"
            , Font.typeface "Lucida Grande"
            , Font.sansSerif
            ]
        , height fill

        -- , Element.htmlAttribute <| Html.Attributes.class ".noselect"
        ]
        (page model)


header : Element Msg
header =
    row
        [ width fill
        , Border.widthEach
            { bottom = 1
            , left = 0
            , right = 0
            , top = 0
            }
        , Border.glow darkGreen 10
        ]
        [ el
            [ Region.heading 1
            , Font.color red
            , Font.size 30
            , padding 30
            , centerX
            ]
            (Element.text "Habit tracker")
        ]


page : Model -> Element Msg
page model =
    column
        [ width fill
        , height fill
        ]
        [ header
        , content model
        , footer model
        ]


content : Model -> Element Msg
content model =
    column
        [ width fill
        ]
        [ row
            [ centerX
            , padding 20
            ]
            [ Element.html <| circle model.circleColor
            , text <| "Antall ganger: " ++ String.fromInt model.numberOfTimes
            ]
        ]


footer : Model -> Element Msg
footer model =
    el [ alignBottom, padding 10 ]
        (text <|
            "Nettverksstatus:"
                ++ networkStatusAsString model.networkStatus
        )


circle : Color -> Html Msg
circle color =
    let
        c =
            case color of
                Black ->
                    "black"

                Red ->
                    "red"
    in
    Svg.svg
        [ Svg.Attributes.width "100"
        , Svg.Attributes.height "100"
        , Svg.Attributes.viewBox "0 0 100 100"
        ]
        [ Svg.circle
            [ Svg.Attributes.cx "50"
            , Svg.Attributes.cy "50"
            , Svg.Attributes.r "40"
            , Svg.Attributes.fill c
            , onClick ClickedCircle
            ]
            []
        ]



-- Colors


darkGreen : Element.Color
darkGreen =
    rgb255 82 142 194


red : Element.Color
red =
    rgb255 215 37 37
