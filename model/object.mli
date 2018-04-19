type info = {speed: int; hp: int}

type mummy = |Normal of info |Conehead of info |Buckethead of info 

type shooter = |Peashooter of info |Cactus of info

type projectile = {shooter: shooter; mutable tile: tile; mutable step: int}

type zombie = {mummy: mummy; mutable pos: tile; mutable hp: int; mutable step: int}

type animated = |Projectile of projectile | Zombie of zombie

type plant = {plant: shooter; mutable tile: tile; mutable HP: int}

type object = |Animated of animated |Static of plant

(* plant a shooter on tile *)
val: plant: shooter -> tile -> plant

(* Moves the animated from the current tile to the next tile *)
val next_tile: animated -> unit

(* Update the step count of animated by one move (=speed)
If step > tile.size, moves animated to the next tile. *)
val move: animated -> unit
