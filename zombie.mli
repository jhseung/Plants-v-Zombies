type zombie = {mutable pos: tile; mutable HP: int}

(* Moves the zombie from the current tile to the next tile *)
val move_zombie: zombie -> unit
