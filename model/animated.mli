type info = {speed: int; hp: int}

type mummy = |Normal of info |Conehead of info |Buckethead of info 

type bean = |Peas of info

type projectile = {bean: bean; mutable tile: tile; mutable step: int}

type zombie = {mummy: mummy; mutable pos: tile; mutable hp: int; mutable step: int}

type animated = |Projectile of projectile | Zombie of zombie

(* Moves the zombie from the current tile to the next tile *)
val next_tile: animated -> unit

(* Update the step count of the zombie by one move (=speed)
If step > tile.size, moves the zombie to the next tile. *)
val move: animated -> unit
