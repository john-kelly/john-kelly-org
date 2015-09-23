# Elm

## What is Elm?
Elm is a functional language for web browser programming.

## Tutorial
### Part 1
#### Hello World
Click [here](http://elm-lang.org/try) to open up the online elm editor. We are going to use the online editor because it does not require any setup on our part.

Once you open up the online editor, paste everyone's favorite program into the editor.

```
import Graphics.Element

main =
  Graphics.Element.show "Hello, Universe!"
```

And click compile. Boom.


#### Functions
```
import Graphics.Element
import String

toUppercase input =
  String.toUpper input

main =
  Graphics.Element.show (toUppercase "Hello, Universe!")
```


## TODO
- embed the editor in blog or site or something.
- may want to look into the debugger implementation
- autograder for the elm code? hmm... check out the unit test framework. (the potential beauty of this... if their code compiles... we don't have to worry about our tests breaking)
