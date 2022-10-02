module ByJovis.Color exposing (linearInterpolation)

import Browser

import Color as C
import Color.Interpolate as CI

import Element exposing (..)
import Element.Background as Background

import Html exposing (Html)

import Round


 -- MAIN


main = Browser.sandbox
        { init = init
        , update = update
        , view = view
        }



 -- MODEL


type alias Model =
    { start : Color
    , end : Color
    , nSteps : Int
    }


init =
    { start = rgb 0 1 0
    , end = rgb 0 0 1
    , nSteps = 1000
    }


 -- UPDATE


update model = model



 -- VIEW


cRange : Float -> Float -> Int -> List Float
cRange start end nInter =
    let
        step = (end - start) / (toFloat <| nInter + 1)
    in
        List.map (\i -> start + (toFloat i) * step) <| List.range 0 (nInter+1)


red : Color -> Float
red = .red << toRgb
green : Color -> Float
green = .green << toRgb
blue : Color -> Float
blue = .blue << toRgb


wrongInterpolation : Color -> Color -> Int -> List Color
wrongInterpolation c1 c2 n =
    List.map3
        rgb
        (cRange (red c1) (red c2) n)
        (cRange (green c1) (green c2) n)
        (cRange (blue c1) (blue c2) n)


linearInterpolation : Color -> Color -> Int -> List Color
linearInterpolation c1 c2 n =
    let
        decode cs =
            if cs <= 0.04045 then
                cs / 12.92
            else
                ((cs + 0.055)/1.055)^2.4

        encode cl =
            if cl <= 0.0031308 then
                12.92 * cl
            else
                1.055 * cl^(1/2.4) - 0.055

        rl1 = decode <| red c1
        rl2 = decode <| red c2
        gl1 = decode <| green c1
        gl2 = decode <| green c2
        bl1 = decode <| blue c1
        bl2 = decode <| blue c2
    in
        List.map3
            (\r g b -> rgb (encode r) (encode g) (encode b))
            (cRange rl1 rl2 n) (cRange gl1 gl2 n) (cRange bl1 bl2 n)


builtinInterpolation : C.Color -> C.Color -> Int -> List C.Color
builtinInterpolation c1 c2 n =
    List.map (\i -> CI.interpolate CI.RGB c1 c2 ((toFloat i)/(toFloat n))) <| List.range 0 (n+1)


view model =
    layout
        [ width fill 
        , height fill
        , clip
        ]
        <| column
            [ width fill
            , height fill
            ]
            [ row
                [ width fill
                , height fill
                ]
                <| List.map
                    colorView
                    (wrongInterpolation model.start model.end model.nSteps)
                , row
                [ width fill
                , height fill
                ]
                <| List.map
                    colorView
                    (linearInterpolation model.start model.end model.nSteps)
                , row
                [ width fill
                , height fill
                ]
                <| List.map
                    (colorView << fromRgb << C.toRgba)
                    <| builtinInterpolation
                        (C.fromRgba <| toRgb model.start)
                        (C.fromRgba <| toRgb model.end)
                        model.nSteps
            ]


colorView : Color -> Element msg
colorView color =
    el
        [ height fill
        , width fill
        , Background.color color
        ]
        none
        -- <| text <|
        --     "(" ++ Round.round 2 r
        --     ++ "," ++ Round.round 2 g
        --     ++ "," ++ Round.round 2 b ++
        --     ")"
