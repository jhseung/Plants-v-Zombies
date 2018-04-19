type state = {tiles: (Tile.tile array) array; mutable sunlight: int}

type objects = {zombies: Object.zombie list; plants: Object.plant list; projectiles: Object.projectile list}

(* Returns the initial state with x columns and y rows. *)
val init_state: int -> int -> state

(* Returns the number of sunlight. *)
val get_sunlight: state -> int

(* Returns the number of sunflowers. *)
val get_sunflowers: state -> int

(* Update all the tiles by one move *)
val update: state -> unit

(* Returns the objects in the state *)
val get_objects: state -> objects

(* Returns the coordinates of the object *)
val get_coordinates: Object.object -> int*int

(* Returns the type of the object as a string id. *)
val get_type: Object.object -> string

(* Updates the state with a new plant at coordinates (x, y) *)
val make_plant: Object.shooter -> int -> int -> unit

(* Updates sthe state with a new zombie at coordinates (x, y) *)
val make_zombie: Object.mummy -> int -> int -> unit

(* Updates the state with get_sunflowers state + 1 sunlight *)
val increase_sunlight: state -> unit

(* Returns true if all the zombies are dead *)
val has_won: state -> bool 

(* Returns true if a zombie is at the leftmost tile and zombie.step >= tile.size *)
val has_lost: state -> bool
