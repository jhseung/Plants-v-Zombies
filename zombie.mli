type zombie = {mutable col: int; mutable row: int}

(* Moves the zombie from the current tile to the next tile *)
val move_zombie: zombie -> unit
