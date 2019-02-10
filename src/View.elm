module View exposing (mainView)

import Dict
import Element exposing (Element, alignBottom, alignRight, centerX, column, el, fill, height, padding, rgb255, row, spaceEvenly, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Hex
import Html exposing (Html)
import Html.Attributes
import Html.Events exposing (onClick)
import Model exposing (Color(..), Counter, Model, Msg(..), networkStatusAsString)
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
            , Font.color niceRed
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
    case model.counters of
        Nothing ->
            noCounterMessage

        Just dict ->
            let
                counters =
                    List.map showCounter <|
                        Dict.values dict
            in
            column
                [ width fill
                ]
                counters


showCounter : Counter -> Element Msg
showCounter counter =
    row
        [ centerX
        , padding 20
        ]
        [ Element.html <| circle Red counter
        , text <| counter.name ++ ": " ++ String.fromInt counter.numberOfTimes
        ]


noCounterMessage : Element Msg
noCounterMessage =
    el [] <|
        text
            "No counters yet."


footer : Model -> Element Msg
footer model =
    row
        [ alignBottom
        , padding 10
        , width fill
        ]
        [ el
            [ alignBottom
            , padding 10
            ]
            (text <|
                "Status :"
                    ++ networkStatusAsString model.networkStatus
            )
        , el
            [ alignRight
            ]
          <|
            Element.html plus
        ]


circle : Color -> Counter -> Html Msg
circle color counter =
    let
        c =
            case color of
                Black ->
                    "black"

                Red ->
                    toHexString niceRed
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
            , onClick <| ClickedCircle counter.id
            ]
            []
        ]


plus : Html Msg
plus =
    Svg.svg
        [ Svg.Attributes.width "100"
        , Svg.Attributes.height "100"
        , Svg.Attributes.viewBox "0 0 100 100"
        ]
        [ Svg.circle
            [ Svg.Attributes.cx "50"
            , Svg.Attributes.cy "50"
            , Svg.Attributes.r "30"
            , Svg.Attributes.fill <|
                toHexString lightBlue
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "40"
            , Svg.Attributes.y "25"
            , Svg.Attributes.width "20"
            , Svg.Attributes.height "50"
            , Svg.Attributes.fill <|
                toHexString darkGrey
            ]
            []
        , Svg.rect
            [ Svg.Attributes.x "25"
            , Svg.Attributes.y "40"
            , Svg.Attributes.width "50"
            , Svg.Attributes.height "20"
            , Svg.Attributes.fill <|
                toHexString darkGrey
            , onClick Model.ClickedPlus
            ]
            []
        ]



-- Colors
-- https://www.color-hex.com/color-palette/73108


lightGrey : Element.Color
lightGrey =
    rgb255 217 217 217


darkGrey : Element.Color
darkGrey =
    rgb255 147 141 141


lightBlue : Element.Color
lightBlue =
    rgb255 129 196 213


darkGreen : Element.Color
darkGreen =
    rgb255 82 142 194


niceRed : Element.Color
niceRed =
    rgb255 215 37 37


toHexString : Element.Color -> String
toHexString color =
    let
        { red, green, blue } =
            Element.toRgb color

        h i =
            Hex.toString <| round (i * 255)
    in
    "#" ++ h red ++ h green ++ h blue
