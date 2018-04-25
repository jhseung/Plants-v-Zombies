open Object
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

(*[available_in_stock f st] is true if the plant [f] clicked in the stock panel
  is available in mega state [st] and false otherwise.
  side effects: If true it makes the plant appears selected. *)
val available_in_stock : flora -> mega -> bool

(*[plant_a_flora f t st] is the mega state [st'] after the mouse clicks the
  flora [f] in stock and then the tile [t] in mega state [st]. If no zombie is
  on tile [t], [f] is planted on [t] in [st'] and the number of flora in stock
  that is the same as [f] is fewer in [st'] than [st] by 1. If a zombie is on
  tile [t], then [st'] is [st].
  requires : [available_in_stock f st] is true.
  side effects : if no zombie is on tile [t], [f] is planted on [t] on the
                 screen;
                 if no zombie is on tile [t] and [f] was the only available
                 flora of its type in the stock, then make its type appear grey
                 in the stock panel on the screen.
*)
val plant_a_flora : flora -> tile -> mega -> mega

(*[collect_sunlight s st] is the mega state [st'] after the mouse clicks the
  sunlight [s] in mega state [st]. Sunlight balance is incremented by an
  unspecified value from [st] to [st'].
  side effects: [s] is eliminated on the screen.
*)
val collect_sunlight : sunlight -> mega -> mega

(*respond to an elapse of time (i.e. do in every time step):
  put sunlight in the garden according to the number of sunflowers present in
  the garden;
  decide whether an uncollected sunlight should disappear.
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
*)

(*[shed_sunlight st] creates sunlights at random positions in the garden in mega
  state [st] and returns the new mega state. The number of sunlights created
  equals the number of sunflowers present in the garden in [st].
  side effects: create sunlights on the screen.
*)
val shed_sunlight : mega -> mega

(*[dissipate_sunlight st] increases the age of each sunlight in [st] by 1 and
  remove the sunlights older than an unspecified age, and returns the new mega
  state.
  side effects: remove the corresponding sunlights on the screen.
*)
val dissipate_sunlight : mega -> mega

(*[add_to_stock st] adds unspecified types and number of flora to the stock in
  [st] and decreases the sunlight balance accordingly to return the new mega
  state.
  side effects: if a flora of a type previously unavailable is added to the
                stock, then make its type colored in the stock panel.*)
val add_to_stock : mega -> mega

(*[add_zombie st] decides whether to let more zombies enter the garden and from
  which lane(s) they enter, and if yes then adds the zombie(s) on the right edge
  of the garden and returns the new mega state, otherwise returns [st].
  side effects: create the added zombie(s) on the screen.*)
val add_zombie : mega -> mega

(*[zombie_walk st] updates the positions of each zombie according to its
  velocity and whether it collides with a plant, after one time step from [st],
  and returns the new mega state.
  side effects: update the positions of each zombie on screen.*)
val zombie_walk : mega -> mega

(*[attack_flora st] lets each zombie attack the flora with which it collides in
  mega state [st], updates the remaining life of each attacked flora and returns
  the new mega state.*)
val attack_flora : mega -> mega

(*[attack_zombie st] lets each shooter shoots a number of projectiles to the
  zombie(s) in the same lane as the shooter, updates the remaining life of each
  attacked zombie and returns the new mega state.
  side effects: show projectiles on the screen.
*)
val attack_zombie : mega -> mega

(*[kill_flora st] removes flora whose remaining life is 0 in mega state [st]
  from the garden and returns the new mega state.
  side effects: remove the corresponding flora on the screen.
*)
val kill_flora : mega -> mega

(*[kill_zombie st] removes zombie whose remaining life is 0 in mega state [st]
  from the garden and returns the new mega state.
  side effects: remove the corresponding zombie on the screen.
*)
val kill_zombie : mega -> mega

(*[check_lost st] is true if a zombie has reached the house in mega state [st].
  side effects: if a zombie has reached the house then print the message telling
                the player he has lost on the screen.*)
val check_lost : mega -> bool

(*[check_win st] is true if no zombie is present in the garden in mega state
  [st].
  side effects: if true then print the message telling the player he has won on
                the screen.*)
val check_win : mega -> bool
