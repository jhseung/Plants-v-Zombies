(* top_left = Cartesian coordinates of the top left corner of the stock panel.
   tiles    = tiles of the garden, containing the location and size of the tiles
              as well as the zombies, plants and projectiles present in the
              tile.
   sunlights= sunlights present in the garden, containing the positions of
              sunlights.
   sun_bal  = balance of sunlights. (Sunlights are used to add as many plants
              as possible to the stock. This is the remaining sunlights that are
              not enough to add a single plant.)
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
  stock: (flora * int) list
}


type object = |Zombie of zombie |Plant of plant |Projectile of projectile

type objects = {zombies: Object.zombie list; plants: Object.plant list
projectiles: Object.projectile list *)

type character = |Z of zombie |P of plant

(* [init_state c r s (x,y)] is the initial state with number of columns [c],
   number of rows [r], tile size [s], and coordinates [(x, y)] for top left
   corner.
   No plant, zombie or projectile is present on any of the tiles in the initial
   state. No sunlight is present in the garden either. Total number of zombies
   and the initial stock is unspecified. *)
val init_state: int -> int -> int -> int*int -> state

(* Returns the number of sunlight. *)
val get_sunlight: state -> int

(* Update all the tiles by one move *)
val update: state -> unit

(* Returns the objects in the state *)
val get_objects: state -> objects

(* Returns the coordinates of the object *)
val get_coordinates: object -> int*int

(* Returns the type of the object, i.e. type of mummy, type of
flora, type of projectile, as a string id. *)
val get_type: object -> string

(* Updates the state with a new plant at coordinates (x, y) *)
val make_plant: Object.shooter -> int -> int -> unit

(* Updates sthe state with a new zombie at coordinates (x, y), state.total -= 1 *)
val make_zombie: Object.mummy -> int -> int -> unit

(* Updates the state with a projectile originating from the plant *)
val make_projectile: Object.plant -> unit

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
val plant_attacked: Object.plant -> bool

(* Returns true if the zombie is being attacked. *)
val zombie_attacked: Object.zombie -> bool

(* Returns true if the zombie is attacking. *)
val zombie_attacking: Object.zombie -> bool

(* Returns true if the projectile is attacking *)
val projectile_attacking: projectile -> bool

(* Returns the hp of the character. *)
val get_hp: character -> int
