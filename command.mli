open State

(*[cards] is the cards to move; [src] is the pile (source) where the cards are;
  [dst] is the pile (destination) where the cards are going.*)
type move = {cards : pile; src : pile; dst : pile}

type command = Look | Move of move | Flip | Restart | Quit | Moves of int
             | Undo | Hint

val parse : string -> command
