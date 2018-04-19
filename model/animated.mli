type info = {speed: int; hp: int}

type mummy = |Normal of info |Conehead of info |Buckethead of info 

type shooter = |Peashooter of info

type projectile = {shooter: shooter; mutable tile: tile; mutable step: int}

type zombie = {mummy: mummy; mutable pos: tile; mutable hp: int; mutable step: int}

type animated = |Projectile of projectile | Zombie of zombie

(* Moves the animated from the current tile to the next tile *)
val next_tile: animated -> unit

(* Update the step count of animated by one move (=speed)
If step > tile.size, moves animated to the next tile. *)
val move: animated -> unit
