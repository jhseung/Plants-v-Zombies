open Mega

(*place holder for now*)
type handle = unit

(*[play_game c r s (x,y)] starts the game with number of columns [c], number of
  rows [r], tile size [s], and coordinates [(x, y)] for top left corner.*)
val play_game : int -> int -> int -> int*int -> unit

(*[player_move h] is the mega state after the mouse clicks by handle [h].
  side effects: deselect any selected flora if this click is not on a flora; if
  it is on a flora then deselect any other selected flora.*)
(*It judges if the mouse clicks the stock, a tile or a sunlight.*)
val player_move : handle -> mega

(*[check_lost st] is true if a zombie has reached the house in mega state [st].
  side effects: if a zombie has reached the house then print the message telling
                the player he has lost on the screen.*)
val check_lost : mega -> bool

(*[check_win st] is true if no zombie is present in the garden in mega state
  [st].
  side effects: if true then print the message telling the player he has won on
                the screen.*)
val check_win : mega -> bool
