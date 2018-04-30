open Mega

(*place holder for now*)
type handle = unit

(*[play_game c r s (x,y)] starts the game with number of columns [c], number of
  rows [r], tile size [s], and coordinates [(x, y)] for top left corner.*)
val play_game : int -> int -> int -> int*int -> unit

(*[player_move h] is the mega state after the mouse clicks by handle [h].*)
(*It judges if the mouse clicks the stock, a tile or a sunlight.*)
val player_move : handle -> mega
