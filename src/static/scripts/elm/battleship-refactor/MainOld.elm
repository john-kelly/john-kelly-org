module Battleship where

-- NOTE

-- TODO
-- Add PlayerTurn Type? Benefit is the ability to move player specific stuff to its own functions
-- How to check for change in state? Do we check at the end of each action or do we check at the beginning of each action??? Is there a better way?
-- what is the right way to find a ship by id? is what the todo mvc does best practice? a filter on id?Options
    -- speaking of id. i rem in the tutorial there was some talk about optimizations b/c of id. must be called id?
-- should probably have two different boards... this way a player does not have to have the opponents board to generate their track......... damn!
-- checking for hits should use getCoordinates instead of iterating over the entire matrix. similar to `canAddShip`

-----------------------------------
-- Premature fucking optmization --
-----------------------------------
-- We could store the state of the board separate from the ships. We really
-- only need the ships to draw.

-- REFERENCE
-- Terminology from: https://en.wikipedia.org/wiki/Battleship_(game)#Description
-- https://github.com/kortaggio/battleboat/blob/gh-pages/js/battleboat.js

import Array
import Html
import Html.Attributes
import Html.Events
import Matrix as M
import String
import Signal

---- MODEL ----
-- Ship --
type Orientation = Horizontal | Vertical
type alias Ship =
    { id : Int
    , length : Int
    , orientation : Orientation
    , location : M.Location
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
    | Hit Int
    | Safe Int
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
    | SetupShipRow Int String
    | SetupShipColumn Int String
    -- TODO Convert this to a single radio button. That way we can get rid of the the need to pass Orientation.
    | SetupShipOrientation Orientation Int Bool
    | AddShip Int
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
                SetupShipRow id rowAsString ->
                    let
                    updateShip s =
                        if s.id == id then
                            {
                             s | location <- (M.location (toIntOrDefaultOrZero rowAsString (M.row s.location)) (M.col s.location))
                            }

                        else s
                    player = model.player1
                    in
                    { model | player1 <-
                        { player | ships <-
                            List.map updateShip model.player1.ships
                        }
                    }
                SetupShipColumn id colAsString ->
                    let
                    updateShip s =
                        if s.id == id then
                            {
                             s | location <- (M.location (M.row s.location) (toIntOrDefaultOrZero colAsString (M.col s.location)))
                            }

                        else s
                    player = model.player1
                    in
                    { model | player1 <-
                        { player | ships <-
                            List.map updateShip model.player1.ships
                        }
                    }
                SetupShipOrientation orientation id isChecked ->
                    let
                    updateShip s = if s.id == id then { s | orientation <- orientation } else s
                    player = model.player1
                    in
                    { model | player1 <-
                        { player | ships <-
                            List.map updateShip model.player1.ships
                        }
                    }
                AddShip id ->
                    let
                        ship = Array.get id (Array.fromList model.player1.ships)
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
                                                ships <- (List.map (\ aShip -> if aShip.id == id then {aShip | isAdded <- fst addShipResult} else aShip) player.ships)
                                            },
                                        state <- if allButOneShipAdded player.ships && fst addShipResult then SetupPlayer2 else model.state
                                    }
                            _ -> model
        SetupPlayer2 ->
            case action of
                NoOp -> model
                SetupShipRow id rowAsString ->
                    let
                    updateShip s =
                        if s.id == id then
                            {
                             s | location <- (M.location (toIntOrDefaultOrZero rowAsString (M.row s.location)) (M.col s.location))
                            }

                        else s
                    player = model.player2
                    in
                    { model | player2 <-
                        { player | ships <-
                            List.map updateShip model.player2.ships
                        }
                    }
                SetupShipColumn id colAsString ->
                    let
                    updateShip s =
                        if s.id == id then
                            {
                             s | location <- (M.location (M.row s.location) (toIntOrDefaultOrZero colAsString (M.col s.location)))
                            }

                        else s
                    player = model.player2
                    in
                    { model | player2 <-
                        { player | ships <-
                            List.map updateShip model.player2.ships
                        }
                    }
                SetupShipOrientation orientation id isChecked ->
                    let
                    updateShip s = if s.id == id then { s | orientation <- orientation } else s
                    player = model.player2
                    in
                    { model | player2 <-
                        { player | ships <-
                            List.map updateShip model.player2.ships
                        }
                    }
                AddShip id ->
                    let
                        ship = Array.get id (Array.fromList model.player2.ships)
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
                                                ships <- (List.map (\ aShip -> if aShip.id == id then {aShip | isAdded <- fst addShipResult} else aShip) player.ships)
                                            },
                                        state <- if allButOneShipAdded player.ships && fst addShipResult then PlayPlayer1 else model.state
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

getShipCoordinates : Ship -> List M.Location
getShipCoordinates ship =
    case ship.orientation of
        Vertical ->
            [0 .. ship.length - 1]
                |> List.map (\num -> M.location ((M.row ship.location) + num) (M.col ship.location))
        Horizontal ->
            [0 .. ship.length - 1]
                |> List.map (\num -> M.location (M.row ship.location) ((M.col ship.location) + num))

primaryGridCellToString : GridCell -> String
primaryGridCellToString gridCell =
    case gridCell of
        Miss -> "!="
        Empty -> " "
        Hit id -> "!"
        Safe id -> toString id

primaryGridToString : Grid -> String
primaryGridToString grid =
    grid |> M.toString primaryGridCellToString {width=3, delimit=' '}

trackingGridCellToString : GridCell -> String
trackingGridCellToString gridCell =
    case gridCell of
        Miss -> "!="
        Hit id -> "!"
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
            Safe id -> False
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
                |> List.foldr (\ coord accGrid -> M.set coord (Safe ship.id) accGrid) grid
        in (True, newGrid)
    else
        (False, grid)

guessShip : M.Location -> Grid -> (Bool, Grid)
guessShip loc opponentGrid =
    case M.get loc opponentGrid of
        Just v -> case v of
            Empty -> (True, M.set loc Miss opponentGrid)
            Safe id -> (True, M.set loc (Hit id) opponentGrid)
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
                        [ Html.Attributes.value (toString (M.row s.location))
                        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << SetupShipRow s.id)
                        ]
                        []
                    , Html.input -- Ship Column Input
                        [ Html.Attributes.value (toString (M.col s.location))
                        , Html.Events.on "input" Html.Events.targetValue (Signal.message address << SetupShipColumn s.id)
                        ]
                        []
                    , Html.input -- Ship Orientation Vertical
                        [ Html.Attributes.type' "radio"
                        , Html.Attributes.checked (s.orientation == Vertical)
                        , Html.Events.on "change" Html.Events.targetChecked (Signal.message address << SetupShipOrientation Vertical s.id)
                        ]
                        []
                    , Html.input -- Ship Orientation Horizontal
                        [ Html.Attributes.type' "radio"
                        , Html.Attributes.checked (s.orientation == Horizontal)
                        , Html.Events.on "change" Html.Events.targetChecked (Signal.message address << SetupShipOrientation Horizontal s.id)
                        ]
                        []
                    , Html.button -- Add Ship
                        [ Html.Events.onClick address (AddShip s.id)
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
