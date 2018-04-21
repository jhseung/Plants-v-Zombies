(* top_left = Cartesian coordinates of the top left corner of the stock panel.
   tiles    = tiles of the garden, containing the location and size of the tiles
              as well as the zombies, plants and projectiles present in the
              tile.
   sunlights= sunlights present in the garden, containing the positions of
              sunlights and number of time steps since they are created.
   sun_bal  = balance of sunlights. (Sunlights are used by the program (not
              player) to add plants to the stock. This is the remaining
              sunlights that have not yet been used to add plants to the stock.)
   total    = total number of zombies to be released.
   stock    = [p1,n1; p2,n2; ...] meaning in the stock there are n1 plants of
              type p1, n2 plants of type p2 ...
*)
type state = {
  top_left: int*int;
  tiles: (Tile.tile array) array;
  sunlights: sunlight list;
  mutable sun_bal : int;
  mutable total: int;
}

type objects = {
  zombies: zombie list;
  plants: plant list;
  projectiles: projectile list
}

type character = |Z of zombie |P of plant


(*position of sunlight and number of time steps since created*)
type sunlight = {pos : int*int; age : int}

(* [init_state c r s (x,y)] is the initial state with number of columns [c],
   number of rows [r], tile size [s], and coordinates [(x, y)] for top left
   corner.
   No plant, zombie or projectile is present on any of the tiles in the initial
   state. No sunlight is present in the garden either. Total number of zombies
   and the initial stock is unspecified. *)
val init_state: int -> int -> int -> int*int -> state

(* Returns the number of sunlight. *)
val get_sunlight: state -> int

(* Update all the objects on every tile by one move *)
val update: state -> unit

(* Returns the objects in the state *)
val get_objects: state -> objects

(* Returns the coordinates of the object *)
val get_coordinates: item -> int*int

(* Returns the type of the object, i.e. type of mummy, type of
flora, type of projectile, as a string id. *)
val get_type: item -> string

(* Updates the state with a new flora at coordinates (x, y) *)
val make_plant: flora -> int * int -> state -> unit

(* Updates the state with a new zombie at coordinates (x, y), state.total -= 1 *)
val make_zombie: mummy -> int * int -> state -> unit

(*[remove_plant f (x,y) st] removes the flora [f] at (x,y) from state [st].*)
val remove_plant: flora -> int * int -> state -> unit

(*[remove_zombie m (x,y) st] removes the zombie [m] at (x,y) from state [st].*)
val remove_zombie: mummy -> int * int -> state -> unit

(* Updates the state with a projectile originating from the plant *)
val make_projectile: plant -> unit

(* Chengyan: Let me decide where to put the sunlights.
(* Updates the state with n additional sunlight, with
n = number of sunflowers *)
val sunflower_sunlight: state -> unit

(* Updates the state with 1 additional sunlight *)
val increase_sunlight: state -> unit
*)

(*[add_sunlight lst st] adds the sunlights specified by the list [lst] to the
  existing sunlights in state [st] and increases the sunlight balance by the
  number of added sunlights.*)
val add_sunlight: sunlight list -> state -> unit

(* Returns true if total = 0 and List.length objects.zombies = 0*)
val has_won: state -> bool

(* Checks for leftmost tiles only *)
(* Returns true if a zombie is at the leftmost tile and zombie.step >= tile.size *)
val has_lost: state -> bool

(* Returns true if the plant is being attacked. *)
val plant_attacked: plant -> bool

(* Returns true if the zombie is being attacked. *)
val zombie_attacked: zombie -> bool

(* Returns true if the zombie is attacking. *)
val zombie_attacking: zombie -> bool

(* Returns true if the projectile is attacking *)
val projectile_attacking: projectile -> bool

(* Returns the hp of the character. *)
val get_hp: character -> int

type stock = (flora * int) list
