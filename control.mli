open Object
open State

(*place holder for now*)
type handle = unit

(*[start_game c r s (x,y)] starts the game with number of columns [c], number of
  rows [r], tile size [s], and coordinates [(x, y)] for top left corner.*)
val start_game : int -> int -> int -> int*int -> unit

(*[player_move h] is the state after the mouse clicks by handle [h].
  side effects: deselect any selected flora if this click is not on a flora; if
  it is on a flora then deselect any other selected flora.*)
(*It judges if the mouse clicks the stock, a tile or a sunlight.*)
val player_move : handle -> state

(*[available_in_stock f st] is true if the plant [f] clicked in the stock panel
  is available in state [st] and false otherwise.
  side effects: If true it makes the plant appears selected. *)
val available_in_stock : flora -> state -> bool

(*[plant_a_flora f t st] is the state [st'] after the mouse clicks the flora [f]
  in stock and then the tile [t] in state [st]. If no zombie is on tile [t], [f]
  is planted on [t] in [st'] and the number of flora in stock that is the same
  as [f] is fewer in [st'] than [st] by 1. If a zombie is on tile [t], then
  [st'] is [st].
  requires : [available_in_stock f st] is true.
*)
val plant_a_flora : flora -> tile -> state -> state

(*[collect_sunlight s st] is the state [st'] after the mouse clicks the sunlight
  [s] in state [st]. Sunlight balance is first incremented by an unspecified
  value, then used to add flora to stock until the remaining balance is not
  enough for a single flora. The remaining balance is stored in [st'].
  side effects: [s] is eliminated on the screen.
*)
val collect_sunlight : sunlight -> state -> state

(*respond to an elapse of time:
  put sunlight in the garden according to the number of sunflowers present in
  the garden;
  pay collected sunlight for more plants and add these plants to stock;
  decide whether to let another zombie(s) enter the garden and from which
  lane(s) they enter;
  update the positions of each zombie according to its velocity and whether it
  collides with a plant;
  let each zombie attack the plant with which it collides.
  decide whether each plant is killed;
  let each shooter shoots a number of projectiles and update the life remaining
  for each zombie;
  decide whether each zombie present is killed;
  decide whether a zombie reaches the house;
  decide whether the player has won.
  decide whether an uncollected sunlight should disappear.
*)
