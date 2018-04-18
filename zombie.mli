type zombie = {mutable pos: tile; mutable hp: int; mutable step: int}

(* Moves the zombie from the current tile to the next tile *)
val move_zombie: zombie -> unit
