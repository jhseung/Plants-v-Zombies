open State
open Sprite

type flora_t = string
type zombie_t = string

(*type that includes all the information of the status of the game, referred to
  as the mega state.
  col = number of columns of tiles.
  row = number of rows of tiles.
  sun = a 2D array whose entry corresponds to each tile, [sun.(c).(r)] is [None]
        if there is no sunlight in the tile at column [c] and row [r] and it is
        [Some age] if there is sunlight in that tile and it has been there for
        [age] steps.
  sun_bal = sun balance, the amount of collected sunlight that has not been used
            by the program to add flora to the stock.
  num_tiles_wout_sun = number of tiles where there is no sunlight.
  stock = list of flora in stock, the entry [(f, s, n)] of the list represents
          that there are a number ([n]) of flora of type [f] in the stock, and
          the flora of type [f] is selected by the player iff [s] is true.
  st = the state of the garden, i.e. positions and health points of flora and
       zombies in the garden. See state.mli for more details.
*)
type mega = {
  col : int;
  row : int;
  sun : int option array array;
  sun_bal : int;
  num_tiles_wout_sun : int;
  stock : (flora_t * bool * int) list;
  mutable st : state;
  sprite_list: sprite list;
}

(* [init_mega c r s (x,y) total] is the initial mega state with number of
   columns [c], number of rows [r], tile size [s], and coordinates [(x, y)] for
   top left corner, [total] the total number of zombies to be released.
   No plant, zombie or projectile is present on any of the tiles in the initial
   state. No sunlight is present in the garden either. *)
val init_mega : int -> int -> int -> int*int -> int -> mega

(*[tile_of_coord (x, y) m] returns [Some (c,r)] if (x,y) is a coordinate
  contained in the tile at column [c] and row [r] in the mega state [m] and
  [None] if (x,y) is not contained in any tile.*)
val tile_of_coord : int*int -> mega -> (int*int) option

(*[get_num_in_stock f m] is the number of the flora of type [f] in the stock in
  the mega state [m].*)
val get_num_in_stock : flora_t -> mega -> int

(*[select_flora_in_stock f m selected] is the mega state after the flora type
  [f] has been selected (when [selected] is true) or deselected (when [selected]
  is false) in the stock panel in mega state [m].*)
val select_flora_in_stock : flora_t -> bool -> mega -> mega

(*[plant_a_flora f (x,y) m] plants a flora of type [f] at coordinates [(x,y)] in
  mega state [m], updates the stock, deselects the flora type in the stock panel
  and returns [(true, m')] where [m'] is the new state, if there is not already
  a plant or zombie on the tile that contains [(x,y)]. It does nothing and
  returns [(false, m)] if there is already a plant or zombie on that tile.*)
val plant_a_flora : flora_t -> int*int -> mega -> bool * mega

(*[sunlight_of_tile (c, r) m] returns [Some age] if there is sunlight in the
  tile at column [c] and row [r] in the mega state [m] and the sunlight has been
  there for [age] steps. It returns [None] if there is no sunlight in that tile.
*)
val sunlight_of_tile : int*int -> mega -> int option

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
