(* total = total number of zombies to be released *)
open Object

type state = {top_left: int*int; tiles: (tile array) array;
mutable sunlight: int; mutable total: int}

type objects = {zombies: zombie list; plants: plant list;
                projectiles: projectile list}

type character = |Z of zombie |P of plant

(* Returns the initial state with number of columns, number of rows,
size, and coordinates (x, y) for top left corner. *)
val init_state: int -> int -> int -> int*int -> state

(* Returns the number of sunlight. *)
val get_sunlight: state -> int

(* Update all the tiles by one move *)
val update: state -> unit

(* Returns the objects in the state *)
val get_objects: state -> objects

(* Returns the coordinates of the object *)
val get_coordinates: item -> int*int

(* Returns the type of the object, i.e. type of mummy, type of
flora, type of projectile, as a string id. *)
val get_type: item -> string

(* Updates the state with a new plant at coordinates (x, y) *)
val make_plant: shooter -> int -> int -> unit

(* Updates sthe state with a new zombie at coordinates (x, y), state.total -= 1 *)
val make_zombie: mummy -> int -> int -> unit

(* Updates the state with a projectile originating from the plant *)
val make_projectile: plant -> unit

(* Updates the state with n additional sunlight, with
n = number of sunflowers *)
val sunflower_sunlight: state -> unit

(* Updates the state with 1 additional sunlight *)
val increase_sunlight: state -> unit

(* Returns true if total = 0 and List.length objects.zombies = 0*)
val has_won: state -> bool

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
