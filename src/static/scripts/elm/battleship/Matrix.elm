-- NOTE we are getting to a point where most of this libray is the same as the
-- elm package. https://github.com/chendrix/elm-matrix/blob/master/src/Matrix.elm
-- NOTE flat matrix vs non flat matrix...

module Matrix where

import Array
import Maybe
import String

{-| An ordered collection of elements, all of a particular type, arranged into `m` rows and `n` columns.
-}
type alias Matrix a = Array.Array (Array.Array a)

{-| A representation of a row number and a column number, used to locate and access elements in a matrix.
-}
type alias Location = (Int, Int)

{-| Turn two integers into a location
-}
location : Int -> Int -> Location
location = (,)

{-| Extract the row number from a location
    row (loc 3 5) == 3
-}
row : Location -> Int
row = fst


{-| Extract the col number from a location
    col (loc 3 5) == 5
-}
col : Location -> Int
col = snd

{-| Matrix Constructor

Initialize a new matrix of size numRows x numCols where initial is the value of
each cell.

Ex.
matrix 3 5 0 -->
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
-}
initialize : Int -> Int -> a -> Matrix a
initialize numRows numCols initial =
     Array.initialize numRows (\ row -> (Array.repeat numCols initial))

get : Location -> Matrix a -> Maybe a
get loc matrix =
    Array.get (row loc) matrix `Maybe.andThen` Array.get (col loc)

set : Location -> a -> Matrix a -> Matrix a
set loc value matrix =
    case Array.get (row loc) matrix of
        Just oldRow -> Array.set (row loc) (Array.set (col loc) value (oldRow)) matrix
        Nothing -> matrix

{-| Convert a matrix to a list of lists
    toList (fromList [[1, 0], [0, 1]]) == [[1, 0], [0, 1]]
-}
toList : Matrix a -> List (List a)
toList m =
    Array.map Array.toList m
        |> Array.toList

{-| Convert a matrix to a single list
    let
      m = fromList [[0, 1], [2, 3], [4, 5]]
    in
      flatten m == [0, 1, 2, 3, 4, 5]
-}
flatten : Matrix a -> List a
flatten m =
    List.concat <| toList m

{-| Apply the function to every element in the matrix
    map not (fromList [[True, False], [False, True]]) == fromList [[False, True], [True, False]]
-}
map : (a -> b) -> Matrix a -> Matrix b
map f m =
    Array.map (Array.map f) m

{-| Apply the function to every element in the list, where the first function argument
is the location of the element.
    let
      m = (square 2 (\_ -> 1))
      f location element = if row location == col location
                            then element * 2
                            else element
    in
      mapWithLocation f m == fromList [[2, 1], [1, 2]]
-}
mapWithLocation : (Location -> a -> b) -> Matrix a -> Matrix b
mapWithLocation f m =
  Array.indexedMap (
    \rowNum row -> Array.indexedMap (
      \colNum element ->
        f (location rowNum colNum) element
    ) row
  ) m

{-| Get the number of columns in a matrix
-}
colCount : Matrix a -> Int
colCount m =
  Array.get 0 m
  |> Maybe.map Array.length
  |> Maybe.withDefault 0


-- NOTE I chose to implement this method in order to avoid having to break
-- abstraction barrier of the Matrix module. Essentially, in order for a Matrix
-- to be converted into a well formatted String, knowledge of implementation
-- is necessary. The line `Array.map (Array.foldl (\ row acc -> acc ++ row) "")`
-- requires the knowledge that a Matrix is an Array (Array a).
-- NOTE Need to test interactions between padding and cell string length.
toString : (a -> String) -> {width:Int, delimit:Char} -> Matrix a -> String
toString cellToString padding m =
    -- padding.width and single pipe for each col and then + 1 for pipe at beginning
    let lineLength = (padding.width + 1) * (colCount m) + 1
    in m
        |> map cellToString
        -- TODO padding could be an optional param with `Maybe`
        |> map (String.pad padding.width padding.delimit)
        |> mapWithLocation (\ loc unit -> if (col loc) == 0 then "|" ++ unit ++ "|" else unit ++ "|")
        -- NOTE HACK We convert to List for access to intersperse. Better way?
        |> Array.toList
        |> List.intersperse (Array.repeat lineLength "-")
        |> (::) (Array.repeat lineLength "-")
        -- NOTE (++) is not commutative, so fold order matters
        |> List.map (Array.foldl (\ row acc -> acc ++ row) "")
        |> List.foldl (\ row acc -> acc ++ row ++ "\n") ""
        |> (\ matrixString -> matrixString ++ (String.repeat lineLength "-") ++ "\n")
