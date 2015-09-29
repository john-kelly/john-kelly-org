import Battleship exposing (main)

main = main

{--import Html
import Battleship exposing (..)

myShip : Ship
myShip =
    { shipId = 1
    , length = 3
    , orientation = Horizontal
    , headCoord = (1, 1)
    }

myOtherShip : Ship
myOtherShip =
    { shipId = 2
    , length = 3
    , orientation = Vertical
    , headCoord = (4, 5)
    }

myGame : Game
myGame =
    game 10 10

board =
    grid 10 10
        |> addShip myShip
        |> snd
        |> addShip myOtherShip
        |> snd
        |> guessShip (1, 1)
        |> snd
        |> guessShip (1, 0)
        |> snd
        |> guessShip (2, 3)
        |> snd
        |> guessShip (1, 5)
        |> snd
        |> guessShip (5, 5)
        |> snd
        |> guessShip (0, 5)
        |> snd
        |> guessShip (2, 9)
        |> snd

main =
    Html.pre []
        [ (Html.text "Primary Grid\n")
        , (Html.text <| primaryGridToString board)
        , (Html.text "Tracking Grid\n")
        , (Html.text <| trackingGridToString board)
        ]
--}
