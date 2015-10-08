import Graphics.Element exposing (..)

try : ( number -> number -> number ) -> number -> number -> number -> number
try fn x guess tolerance =
    let try' guess prev =
        if (abs (guess - prev)) < tolerance then guess
        else try' (fn x guess) guess
    in try' guess 0


sqrt : number -> number
sqrt x =
  try (\x guess -> (guess + x / guess) / 2) x 1 0.0001

main : Element
main =
  show (sqrt 90)
