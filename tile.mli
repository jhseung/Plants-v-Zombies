type tile = {x: int; y: int; size: int; mutable zombies: zombie list; 
mutable plant: plant option; mutable left: tile; mutable right: tile}

type object = |Zombie of zombie |Projectile of projectile

val init_tile: int -> int -> int -> tile

(* Checks if an object is on a tile *)
val on_tile: tile -> object -> bool

