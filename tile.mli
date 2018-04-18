type tile = {x: int; y: int; size: int; mutable zombies: zombie list; 
mutable plant: plant option; left: tile; right: tile; 
mutable projectiles: projectile list}

type object = |Zombie of zombie |Projectile of projectile

val init_tile: int -> int -> int -> tile

(* Checks if an object is on a tile *)
val on_tile: tile -> object -> bool

(* Update all the mutable types on the tile by one move. *)
val update: tile -> unit
