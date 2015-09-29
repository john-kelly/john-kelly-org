module Main where

import Graphics.Element

{-----------------------------------------------------------------

Exercises:

(1) Sum all of the elements of a tree.

       sum : Tree Number -> Number

(2) Flatten a tree into a list.

       flatten : Tree a -> List a

(3) Check to see if an element is in a given tree.

       isElement : a -> Tree a -> Bool

(4) Write a general fold function that acts on trees. The fold
    function does not need to guarantee a particular order of
    traversal.

       fold : (a -> b -> b) -> b -> Tree a -> b

(5) Use "fold" to do exercises 1-3 in one line each. The best
    readable versions I have come up have the following length
    in characters including spaces and function name:
      sum: 16
      flatten: 21
      isElement: 46
    See if you can match or beat me! Don't forget about currying
    and partial application!

(6) Can "fold" be used to implement "map" or "depth"?

(7) Try experimenting with different ways to traverse a
    tree: pre-order, in-order, post-order, depth-first, etc.
    More info at: http://en.wikipedia.org/wiki/Tree_traversal

-----------------------------------------------------------------}

-- Evan's Tree Definition --
type Tree a
    = Empty
    | Node a (Tree a) (Tree a)

empty : Tree a
empty =
    Empty

singleton : a -> Tree a
singleton v =
    Node v Empty Empty

insert : comparable -> Tree comparable -> Tree comparable
insert x tree =
    case tree of
      Empty ->
          singleton x

      Node y left right ->
          if  | x > y -> Node y left (insert x right)
              | x < y -> Node y (insert x left) right
              | otherwise -> tree

fromList : List comparable -> Tree comparable
fromList xs =
    List.foldl insert empty xs
-- Evan's Tree Definition --

-- ################ --
-- ################ --
--     (1) Sum      --
-- ################ --
-- ################ --
-- TODO change Int to Number
sum : Tree Int -> Int
sum tree =
    case tree of
        Empty -> 0
        Node v left right ->
            v + (sum right) + (sum left)
-- ################ --
-- ################ --
--   (2) Flatten    --
-- ################ --
-- ################ --
flatten : Tree a -> List a
flatten tree =
    case tree of
        Empty -> []
        Node v left right ->
            flatten left ++ [v] ++ flatten right
-- ################ --
-- ################ --
--   (3) isElement  --
-- ################ --
-- ################ --
isElement : a -> Tree a -> Bool
isElement elem tree =
    case tree of
        Empty -> False
        Node v left right ->
            v == elem || isElement elem left || isElement elem right
-- ################ --
-- ################ --
--     (4) Fold     --
-- ################ --
-- ################ --
--FROM ELM DOCS http://package.elm-lang.org/packages/elm-lang/core/1.0.0/List
--foldl : (a -> b -> b) -> b -> List a -> b
--Reduce a list from the left.
--foldl (::) [] [1,2,3] == [3,2,1]
-- right
--Graphics.Element.show <| (List.foldr (-) 0 [1,2,3])
-- 1 - (2 - (3 - 0)) == 2
-- left
-- Graphics.Element.show <| (List.foldl (-) 0 [1,2,3])
-- 3 - (2 - (1 - 0)) == 2
-- right
-- Graphics.Element.show <| (List.foldr (-) 0 [3,2,1])
-- 3 - (2 - (1 - 0)) == 2
-- left
-- Graphics.Element.show <| (List.foldl (-) 0 [3,2,1])
-- 1 - (2 - (3 - 0)) == 2

--https://en.wikipedia.org/wiki/Fold_(higher-order_function)#Folds_as_structural_transformations
--great picture!!!

--Nice math definition!!!!
--http://jeremykun.com/2013/09/30/the-universal-properties-of-map-fold-and-filter/
--Finally, fold is a function which “reduces” a list L of entries with type A down to a single value of type B. It accepts as input a function f : A \times B \to B, and an initial value v \in B, and produces a value of type B by recursively applying f as follows:
-- fun fold(_, v, nil) = v
--  | fold(f, v, (head::tail)) = f(head, fold(f, v, tail))

-- http://wiki.tcl.tk/17983
-- Poor wording but great point
-- There are two things to notice here. First, foldl works left-to-right, while foldr works in reverse. The second is the order in which our initial value was combined with the list. In both cases, the initial value was the first value, and the appropriate end of the list was the second. This is important.

--Some important closing comments
-- But what of the case of (foldr (-) 0 t1)? I would assume it would return
-- ((start - 3) - 2) - 1 BUT it returns 1 - (2 - (3 - start))
--http://stackoverflow.com/questions/25158780/difference-between-reduce-and-foldleft-fold-in-functional-programming-particula

foldr : (a -> b -> b) -> b -> Tree a -> b
foldr f curr tree =
    case tree of
      Empty -> curr
      Node v left right ->
          -- In order
          foldr f (f v (foldr f curr right)) left
          -- Pre order
          -- foldr f (foldr f (f v curr) right) left
          -- Post order
          -- f v (foldr f (foldr f curr right) left)

foldl : (a -> b -> b) -> b -> Tree a -> b
foldl f curr tree =
    case tree of
      Empty -> curr
      Node v left right ->
          -- In order
          foldl f (f v (foldl f curr left) ) right
          -- Pre order
          -- foldl f (foldl f (f v curr) left) right
          -- Post order
          -- f v (foldl f (foldl f curr left) right)

{-- Some Testing for foldl and foldr
t1 = fromList [1,2,3]
t2 = fromList [10]
main =
  Graphics.Element.show <| (foldr (::) [] t1)
--}
-- ################ --
-- ################ --
-- (5)Folding Stuff --
-- ################ --
-- ################ --
-- TODO change Int to Number
sum2 : Tree Int -> Int
sum2 t = foldr (+) 0 t

flatten2 : Tree a -> List a
flatten2 t = foldr (::) [] t

isElement2 : a -> Tree a -> Bool
isElement2 el t = foldr (\ v is -> v == el || is) False t


-- ################ --
-- ################ --
-- (6)Map and Depth --
-- ################ --
-- ################ --

-- difficulty with these two is in how both algo's make use of the left and
-- right trees. we do not explicity have access or knowledge of right vs left..
-- so things are a bit tricky

-- This converts to a List, we want a Tree
--map2 : (a -> b) -> Tree a -> List b
--map2 f t = foldr (\ v acc -> (f v) :: acc) [] t

-- not sure if this is possible without rebuilding an entire tree with
-- insert or fromList... would love to see what Evan thinks.
-- Master programers know when something is not possible.
map2 : (comparable  -> comparable ) -> Tree comparable  -> Tree comparable
map2 f t = fromList (foldr (\ v acc -> (f v) :: acc) [] t)

--not sure if this is possible... the issue is that we have no ability to
--distinguish between right and left trees. fold abstracts away left and right
--tree thoughts. fold allows the user to operate on the tree like it were a
--flat list or array or whatever.
{--
depth2 : Tree a -> Int
depth2 tree =
    case tree of
        Empty -> 0
        Node v left right ->
            1 + max (depth2 left) (depth2 right)
--}

-- TODO
-- document all the things
-- http://jwb.io/20121224-understanding-map-filter-and-fold.html
-- http://learnyouahaskell.com/higher-order-functions

t1 = fromList [1,2,3,10]
t2 = fromList [10]
main =
    Graphics.Element.show <| map2 (\v->v*v) t1
