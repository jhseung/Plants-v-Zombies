open State

type flora_t = string
type zombie_t = string

(*[st] is the state of the garden (zombies, plants and etc., specified by
  state.mli).
  [stock] = [p1,n1; p2,n2; ...] meaning in the stock there are n1 flora of
             type p1, n2 flora of type p2 ...
*)
type mega

(* [init_mega c r s (x,y) total] is the initial mega state with number of
   columns [c], number of rows [r], tile size [s], and coordinates [(x, y)] for
   top left corner, [total] the total number of zombies to be released.
   No plant, zombie or projectile is present on any of the tiles in the initial
   state. No sunlight is present in the garden either. *)
val init_mega : int -> int -> int -> int*int -> int -> mega

(*[get_num_in_stock f m] is the number of the flora of type [f] in the stock in
  the mega state [m].*)
val get_num_in_stock : flora_t -> mega -> int

(*[select_flora_in_stock f m selected] is the mega state after the flora type
  [f] has been selected (when [selected] is true) or deselected (when [selected]
  is false) in the stock panel in mega state [m].*)
val select_flora_in_stock : flora_t -> bool -> mega -> mega

(*[plant_a_flora f (x,y) m] plants a flora of type [f] at coordinates [(x,y)] in
  mega state [m], updates the stock, deselects the flora type in the stock panel
  and returns the new state.*)
val plant_a_flora : flora_t -> int*int -> mega -> mega

(*[collect_sunlight (c,r) m] is the mega state after the mouse clicks the tile
  at column [c] and row [r] where there is sunlight, in mega state [m].
  Sunlight balance is incremented by an unspecified value. The sunlight in that
  tile is removed.
*)
val collect_sunlight : int*int -> mega -> mega

(*[update_mega m] updates the mega state [m] by one step and returns the new
  mega state, i.e.
  puts sunlight in the garden according to the number of sunflowers present in
  the garden (this alone is done only once every five calls to update_mega);
  makes the uncollected sunlight that have been present for a while disappear;
  pays collected sunlight for more plants and add these plants to stock;
  adds a random number (can be 0) of zombies at the right edge of the garden
  (in random rows);
  updates the positions of each zombie according to its velocity and whether it
  collides with a plant;
  lets each zombie attack the plant with which it collides.
  lets each shooter shoots a number of projectiles and updates the health point
  for each zombie;
  removes the plants and zombies that are killed.
*)
val update_mega : mega -> mega
