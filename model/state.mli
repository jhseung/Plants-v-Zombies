open Object

(* top_left = Cartesian coordinates of the top left corner of the stock panel.
   tiles    = tiles of the garden, containing the location and size of the tiles
              as well as the zombies, plants and projectiles present in the
              tile.
   sunlight = number of new sunlight.
   total    = total number of zombies to be released.
*)
type state = {
  top_left: int*int;
  tiles: (tile array) array;
  size: int;
  mutable sunlight: int;
  mutable total: int;
}

type objects = |Zombie of zombie |Plant of plant |Projectile of projectile

type character = |Z of zombie |P of plant


(*position of sunlight and number of time steps since created*)
(*type sunlight = {pos : int*int; age : int}*)

(* [init_state c r s (x,y) total] is the initial state with number of columns [c],
   number of rows [r], tile size [s], and coordinates [(x, y)] for top left
   corner, [total] the total number of zombies to be released.
   No plant, zombie or projectile is present on any of the tiles in the initial
   state. No sunlight is present in the garden either. *)
val init_state: int -> int -> int -> int*int -> int -> state

(* Updates the state with a new flora at coordinates (x, y)
   If the corresponding tile has tile.plant != None then do nothing.
   Requirs:
   String [s] represents a valid flora type id
   The (x, y) coordinats are within the boundary of the tiles array. *)
val make_plant: string -> int * int -> state -> unit

(* Updates the state with a new zombie at coordinates (x, y), state.total -= 1
   Requirs:
   String [s] represents a valid zombie type id
   The (x, y) coordinats are within the boundary of the tiles array. *)
val make_zombie: string -> int * int -> state -> unit

(*TODO*)
(* Returns the number of sunlight. *)
(*val get_sunlight: state -> int

(* Update all the objects on every tile by one move *)
val update: state -> unit

(* Returns the objects in the state *)
val get_objects: state -> object list

(* Returns the coordinates of the object *)
val get_coordinates: item -> int*int

(* Returns the type of the object, i.e. type of mummy, type of
flora, type of projectile, as a string id. *)
val get_type: item -> string


(*[remove_plant (x,y) st] removes the flora at (x,y) from state [st] if
  it there is an object of type flora on the corresponding tile.*)
val remove_plant: int * int -> state -> unit

(*
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

(* Returns the hp of the character. *)
  val get_hp: character -> int*)
