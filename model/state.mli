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

type ob = |Zombie of zombie |Plant of plant |Projectile of projectile

(*type objects =
  {
    zombies: zombie list;
    plants: plant list;
    projectiles: projectile list
  }*)

type character = |Z of zombie |P of flora


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
   The (x, y) coordinats are within the boundary of the tiles array.
   Returns true if the plant has been planted, false otherwise (a plant
   is already on the tile or there are zombies on the tile)*)
val make_plant: string -> int * int -> state -> bool

(* Updates the state with a new zombie at coordinates (x, y), state.total -= 1
   Requirs:
   String [s] represents a valid zombie type id
   The (x, y) coordinats are within the boundary of the tiles array. *)
val make_zombie: string -> int * int -> state -> unit

(* Update all the objects on every tile by one move *)
val update: state -> unit

(* Returns the number of new sunlight produced by the state [st]. *)
val get_sunlight: state -> int

(* Returns the type of the ob, i.e. type of mummy, type of
   flora, type of projectile, as a string id. 
   "peashooter" for peashooter
   "sunflower" for sunflower
   "ocaml" for zombie *)
val get_type: ob -> string

(* Returns the all typd ob in state [st] *)
val get_objects: state -> ob list

(* Returns true if a zombie is at the leftmost tile and zombie.step >= tile.size *)
val has_lost: state -> bool

(* Returns the coordinates of type ob *)
val get_coordinates: ob -> int*int

(* Returns true if total = 0 and List.length objects.zombies = 0*)
val has_won: state -> bool

(*TODO*)

(*

(*[remove_plant (x,y) st] removes the flora at (x,y) from state [st] if
  it there is an object of type flora on the corresponding tile.*)
val remove_plant: int * int -> state -> unit

(* Returns true if the plant is being attacked. *)
val plant_attacked: plant -> bool

(* Returns true if the zombie is being attacked. *)
val zombie_attacked: zombie -> bool

(* Returns true if the zombie is attacking. *)
val zombie_attacking: zombie -> bool

(* Returns the hp of the character. *)
  val get_hp: character -> int*)
