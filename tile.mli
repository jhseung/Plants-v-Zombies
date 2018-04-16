type tile = {x: int; y: int; size: int; mutable zombies: zombie list; mutable plant: plant option}

type object = |Zombie of zombie |Bean of bean

val init_tile: int -> int -> int -> tile

(* Checks if an object is on a tile *)
val in_range: tile -> object -> bool

(* Moves the zombie from the current tile to the next tile *)
val move_zombie: zombie -> unit
