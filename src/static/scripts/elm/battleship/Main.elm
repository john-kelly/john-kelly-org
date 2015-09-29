module Battleship where

-- NOTE
-----------------------------------
-- Premature fucking optmization --
-----------------------------------
-- We could store the state of the board separate from the ships. We really
-- only need the ships to draw.

-----------------------------------
-- State Machines for the win??? --
-----------------------------------
-- We may want to create a more explicit state machine?
-- type State = Player1Turn | Player2Turn

-- REFERENCE
-- Terminology from: https://en.wikipedia.org/wiki/Battleship_(game)#Description
-- https://github.com/kortaggio/battleboat/blob/gh-pages/js/battleboat.js

import Array
import Html
import Html.Attributes
import Html.Events
import Json.Decode
import Matrix as M
import Maybe exposing (Maybe)
import String
import Signal

---- MODEL ----
-- Ship --
type Orientation = Horizontal | Vertical | NotSet
type alias ShipId = Int
type alias Ship =
    { shipId : ShipId
    , length : Int
    , orientation : Orientation
    , headCoord : M.Location
    , isAdded : Bool
    }
defaultShips : List Ship
defaultShips =
    [ Ship 0 2 Horizontal (M.location 0 0) False
    , Ship 1 3 Horizontal (M.location 0 0) False
    , Ship 2 4 Horizontal (M.location 0 0) False
    ]
-- Grid Cell --
type GridCell
    = Miss
    | Empty
    | Hit ShipId
    | Safe ShipId
-- Grid --
type GridType = TrackingGrid | PrimaryGrid
type alias Grid = M.Matrix GridCell
grid : Int -> Int -> Grid
grid numRows numCols =
    M.initialize numRows numCols Empty
-- Player --
type alias Player =
    { grid: Grid
    , ships: List Ship
    }
player : Int -> Int -> Player
player numRows numCols =
    { grid = grid numRows numCols
    , ships = defaultShips
    }

-- TODO make PlayerTurn type...
-- State --
type State
    = SetupPlayer1
    | SetupPlayer2
    | PlayPlayer1
    | PlayPlayer2
    | GameOver String

-- Game --
-- The full application state of our todo app.
type alias Game =
    { player1 : Player
    , player2 : Player
    , state : State
    , shootRow : Int
    , shootColumn : Int
    }
game : Int -> Int -> Game
game numRows numCols =
    { player1 = player numRows numCols
    , player2 = player numRows numCols
    , state = SetupPlayer1
    , shootRow = 0
    , shootColumn = 0
    }
----------------

---- UPDATE ----
-- A description of the kinds of actions that can be performed on the model of
-- our application. See the following post for more info on this pattern and
-- some alternatives: http://elm-lang.org/learn/Architecture.elm
type Action
    = NoOp
    | SetupShipRow ShipId String
    | SetupShipColumn ShipId String
    | SetupShipOrientation ShipId String
    | AddShip ShipId
    | SetupShootRow String
    | SetupShootColumn String
    | Shoot

-- How we update our Model on a given Action?
update : Action -> Game -> Game
update action model =
    case model.state of
        SetupPlayer1 ->
            case action of
                NoOp -> model
                SetupShipRow shipId rowAsString ->
                    let
                    updateShip s =
                        if s.shipId == shipId then
                            {
                             s | headCoord <- (M.location (toIntOrDefaultOrZero rowAsString (M.row s.headCoord)) (M.col s.headCoord))
                            }

                        else s
                    player = model.player1
                    in
                    { model | player1 <-
                        { player | ships <-
                            List.map updateShip model.player1.ships
                        }
                    }
                SetupShipColumn shipId colAsString ->
                    let
                    updateShip s =
                        if s.shipId == shipId then
                            {
                             s | headCoord <- (M.location (M.row s.headCoord) (toIntOrDefaultOrZero colAsString (M.col s.headCoord)))
                            }

                        else s
                    player = model.player1
                    in
                    { model | player1 <-
                        { player | ships <-
                            List.map updateShip model.player1.ships
                        }
                    }
                SetupShipOrientation shipId orientAsString ->
                    let
                    updateShip s =
                        if s.shipId == shipId then
                            {
                             s | orientation <- orientationFromStringOrDefault orientAsString s.orientation
                            }

                        else s
                    player = model.player1
                    in
                    { model | player1 <-
                        { player | ships <-
                            List.map updateShip model.player1.ships
                        }
                    }
                AddShip shipId ->
                    let
                        ship = Array.get shipId (Array.fromList model.player1.ships)
                        player = model.player1
                        grid = model.player1.grid
                    in
                        case ship of
                            Just s ->
                                let
                                    addShipResult = addShip s grid
                                in
                                    { model |
                                        player1 <-
                                            { player |
                                                grid <- snd addShipResult,
                                                -- I hate everything.
                                                ships <- (List.map (\ aShip -> if aShip.shipId == shipId then {aShip | isAdded <- fst addShipResult} else aShip) player.ships)
                                            },
                                        -- TODO this logic belongs at the TOP of the state!!!
                                        state <- if allButOneShipAdded player.ships then SetupPlayer2 else model.state
                                    }
                            _ -> model
        SetupPlayer2 ->
            case action of
                NoOp -> model
                SetupShipRow shipId rowAsString ->
                    let
                    updateShip s =
                        if s.shipId == shipId then
                            {
                             s | headCoord <- (M.location (toIntOrDefaultOrZero rowAsString (M.row s.headCoord)) (M.col s.headCoord))
                            }

                        else s
                    player = model.player2
                    in
                    { model | player2 <-
                        { player | ships <-
                            List.map updateShip model.player2.ships
                        }
                    }
                SetupShipColumn shipId colAsString ->
                    let
                    updateShip s =
                        if s.shipId == shipId then
                            {
                             s | headCoord <- (M.location (M.row s.headCoord) (toIntOrDefaultOrZero colAsString (M.col s.headCoord)))
                            }

                        else s
                    player = model.player2
                    in
                    { model | player2 <-
                        { player | ships <-
                            List.map updateShip model.player2.ships
                        }
                    }
                SetupShipOrientation shipId orientAsString ->
                    let
                    updateShip s =
                        if s.shipId == shipId then
                            {
                             s | orientation <- orientationFromStringOrDefault orientAsString s.orientation
                            }

                        else s
                    player = model.player2
                    in
                    { model | player2 <-
                        { player | ships <-
                            List.map updateShip model.player2.ships
                        }
                    }
                AddShip shipId ->
                    let
                        ship = Array.get shipId (Array.fromList model.player2.ships)
                        player = model.player2
                        grid = model.player2.grid
                    in
                        case ship of
                            Just s ->
                                let
                                    addShipResult = addShip s grid
                                in
                                    { model |
                                        player2 <-
                                            { player |
                                                grid <- snd addShipResult,
                                                -- I hate everything.
                                                ships <- (List.map (\ aShip -> if aShip.shipId == shipId then {aShip | isAdded <- fst addShipResult} else aShip) player.ships)
                                            },
                                        -- TODO this logic belongs at the TOP of the state!!!
                                        state <- if allButOneShipAdded player.ships then PlayPlayer1 else model.state
                                    }
                            _ -> model
        PlayPlayer1 ->
            let isGameOverResult = isGameOver model
            in
            if (fst isGameOverResult) then
                { model | state <- GameOver (snd isGameOverResult) }
            else
                case action of
                SetupShootRow rowAsString ->
                    { model | shootRow <- toIntOrDefaultOrZero rowAsString model.shootRow }
                SetupShootColumn columnAsString ->
                    { model | shootColumn <- toIntOrDefaultOrZero columnAsString model.shootColumn }
                Shoot ->
                    let
                        shootResult = guessShip (M.location model.shootRow model.shootColumn) model.player2.grid
                        player = model.player2
                    in
                        if fst shootResult then
                            { model |
                                player2 <-
                                    { player | grid <- snd shootResult },
                                state <- PlayPlayer2
                            }
                        else model
                _ -> model

        PlayPlayer2 ->
            let isGameOverResult = isGameOver model
            in
            if (fst isGameOverResult) then
                { model | state <- GameOver (snd isGameOverResult) }
            else
                case action of
                SetupShootRow rowAsString ->
                    { model | shootRow <- toIntOrDefaultOrZero rowAsString model.shootRow }
                SetupShootColumn columnAsString ->
                    { model | shootColumn <- toIntOrDefaultOrZero columnAsString model.shootColumn }
                Shoot ->
                    let
                        shootResult = guessShip (M.location model.shootRow model.shootColumn) model.player1.grid
                        player = model.player1
                    in
                        if fst shootResult then
                            { model |
                                player1 <-
                                    { player | grid <- snd shootResult },
                                state <- PlayPlayer1
                            }
                        else model
                _ -> model
        GameOver gameOverMessage ->
            model
        _ ->
            case action of
                _ -> model

toIntOrDefaultOrZero : String -> Int -> Int
toIntOrDefaultOrZero stringToConvert default =
    if stringToConvert == "" then 0 else
    case String.toInt stringToConvert of
        Ok n -> n
        _ -> default

orientationToString : Orientation -> String
orientationToString o =
    case o of
        Vertical ->
            "V"
        Horizontal ->
            "H"
        NotSet ->
            ""
orientationFromStringOrDefault : String -> Orientation -> Orientation
orientationFromStringOrDefault s default =
    if  | s == "V" -> Vertical
        | s == "H" -> Horizontal
        | s == "" -> NotSet
        | otherwise -> default

getShipCoordinates : Ship -> List M.Location
getShipCoordinates ship =
    case ship.orientation of
        Vertical ->
            [0 .. ship.length - 1]
                |> List.map (\num -> M.location ((M.row ship.headCoord) + num) (M.col ship.headCoord))
        Horizontal ->
            [0 .. ship.length - 1]
                |> List.map (\num -> M.location (M.row ship.headCoord) ((M.col ship.headCoord) + num))

primaryGridCellToString : GridCell -> String
primaryGridCellToString gridCell =
    case gridCell of
        Miss -> "!="
        Empty -> " "
        Hit shipId -> "!"
        Safe shipId -> toString shipId

primaryGridToString : Grid -> String
primaryGridToString grid =
    grid |> M.toString primaryGridCellToString {width=3, delimit=' '}

trackingGridCellToString : GridCell -> String
trackingGridCellToString gridCell =
    case gridCell of
        Miss -> "!="
        Hit shipId -> "!"
        _ -> " "

trackingGridToString : Grid -> String
trackingGridToString grid =
    grid |> M.toString trackingGridCellToString {width=3, delimit=' '}

allButOneShipAdded : List Ship -> Bool
allButOneShipAdded ships =
    ships
        |> List.map (\{isAdded} -> isAdded)
        |> List.filter (not << identity)
        |> List.length
        |> (==) 1

isGameOver : Game -> (Bool, String)
isGameOver theGame =
    let isNotSafeCell cell =
        case cell of
            Safe shipId -> False
            _ -> True
    in
    let
    player1Lost = theGame.player1.grid
        |> M.flatten
        |> List.map isNotSafeCell
        |> List.foldr (&&) True
    player2Lost = theGame.player2.grid
        |> M.flatten
        |> List.map isNotSafeCell
        |> List.foldr (&&) True
    in
    if | player1Lost -> (True, "Game Over. Player 2 Wins!")
       | player2Lost -> (True, "Game Over. Player 1 Wins!")
       | otherwise -> (False, "")



canAddShip : Ship -> Grid -> Bool
canAddShip ship grid =
    (ship.orientation /= NotSet)
    &&
    (getShipCoordinates ship
        |> List.map (\ coord -> M.get coord grid)
        |> List.foldr (\ v acc ->
            case v of
                Just Empty -> True && acc
                _ -> False
        ) True
    )

addShip : Ship -> Grid -> (Bool, Grid)
addShip ship grid =
    if canAddShip ship grid then
        let newGrid =
            getShipCoordinates ship
                |> List.foldr (\ coord accGrid -> M.set coord (Safe ship.shipId) accGrid) grid
        in (True, newGrid)
    else
        (False, grid)

guessShip : M.Location -> Grid -> (Bool, Grid)
guessShip loc opponentGrid =
    case M.get loc opponentGrid of
        Just v -> case v of
            Empty -> (True, M.set loc Miss opponentGrid)
            Safe shipId -> (True, M.set loc (Hit shipId) opponentGrid)
            _ -> (False, opponentGrid)
        _ -> (False, opponentGrid)

---- VIEW ----
view : Signal.Address Action -> Game -> Html.Html
view address model =
    case model.state of
        SetupPlayer1 ->
            Html.div []
                [ Html.div [] [Html.text "Player 1 Turn"]
                , gridView model.player1 PrimaryGrid
                , controlsView address model.player1 model
                ]
        SetupPlayer2 ->
            Html.div []
                [ Html.div [] [Html.text "Player 2 Turn"]
                , gridView model.player2 PrimaryGrid
                , controlsView address model.player2 model
                ]
        PlayPlayer1 ->
            Html.div []
                [ Html.div [] [Html.text "Player 1 Turn"]
                , gridView model.player1 PrimaryGrid
                , gridView model.player2 TrackingGrid
                , controlsView address model.player1 model
                ]
        PlayPlayer2 ->
            Html.div []
                [ Html.div [] [Html.text "Player 2 Turn"]
                , gridView model.player2 PrimaryGrid
                , gridView model.player1 TrackingGrid
                , controlsView address model.player2 model
                ]
        GameOver gameOverMessage->
            Html.div [] [ Html.text gameOverMessage ]

gridView : Player -> GridType -> Html.Html
gridView player gridType =
    let myStyle =
        Html.Attributes.style
            [ ("display", "inline-block")
            , ("text-align", "center")
            , ("margin", "5px")
            ]
    in
    case gridType of
        TrackingGrid ->
            Html.div [ myStyle ]
                [ Html.text "Tracking Grid"
                , Html.pre [] [ Html.text <| trackingGridToString player.grid ]
                ]
        PrimaryGrid ->
            Html.div [ myStyle ]
                [ Html.text "Primary Grid"
                , Html.pre [] [ Html.text <| primaryGridToString player.grid ]
                ]

setupControlsView : Signal.Address Action -> Player -> Html.Html
setupControlsView address p =
    Html.div []
        (p.ships
            |> List.map (\ s ->
                if not s.isAdded then
                    Html.div []
                    [ Html.input -- Ship Row Input
                        [ Html.Attributes.value (toString (M.row s.headCoord))
                        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << SetupShipRow s.shipId)
                        ]
                        []
                    , Html.input -- Ship Column Input
                        [ Html.Attributes.value (toString (M.col s.headCoord))
                        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << SetupShipColumn s.shipId)
                        ]
                        []
                    , Html.input -- Ship Orientation Input
                        [ Html.Attributes.value (orientationToString s.orientation)
                        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << SetupShipOrientation s.shipId)
                        ]
                        []
                    , Html.button -- Add Ship
                        [ Html.Events.onClick address (AddShip s.shipId)
                        ]
                        []
                    ]
                else Html.div [] []

            )
        )

playControlsView : Signal.Address Action -> Player -> Game -> Html.Html
playControlsView address p theGame =
    Html.div []
    [ Html.input -- Ship Row Input
        [ Html.Attributes.value (toString theGame.shootRow)
        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << SetupShootRow)
        ]
        []
    , Html.input -- Ship Column Input
        [ Html.Attributes.value (toString theGame.shootColumn)
        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << SetupShootColumn)
        ]
        []
    , Html.button -- Shoot Ship
        [ Html.Events.onClick address Shoot ]
        []
    ]

controlsView : Signal.Address Action -> Player -> Game -> Html.Html
controlsView address p theGame =
    case theGame.state of
        SetupPlayer1  -> setupControlsView address p
        SetupPlayer2 -> setupControlsView address p
        PlayPlayer1 -> playControlsView address p theGame
        PlayPlayer2 -> playControlsView address p theGame
        _ -> Html.div [] []
----------------

---- Inputs ----
-- actions from user input
actions : Signal.Mailbox Action
actions =
    Signal.mailbox NoOp
-- manage the model of our application over time
model : Signal Game
model =
    Signal.foldp update initialModel actions.signal
initialModel : Game
initialModel =
    game 10 10
-- wire the entire application together
main : Signal Html.Html
main =
    Signal.map (view actions.address) model
----------------
