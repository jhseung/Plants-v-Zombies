type info = {speed: int; hp: int}

type mummy = |Normal of info |Conehead of info |Buckethead of info 

type shooter = |Peashooter of info |Cactus of info

type projectile = {shooter: shooter; mutable tile: tile; mutable step: int}

type zombie = {mummy: mummy; mutable pos: tile; mutable hp: int; mutable step: int}

type moving = |Projectile of projectile | Zombie of zombie

type flora = |Shooter of shooter |Sunflower

type plant = {plant: shooter; mutable tile: tile; mutable HP: int}

type object = |Moving of moving |Static of plant

(* plant a shooter on tile *)
val: plant: shooter -> tile -> plant

(* Moves the moving object from the current tile to the next tile *)
val next_tile: animated -> unit

(* Update the step count of the moving object by one move (=speed)
If step >= tile.size, moves moving object to the next tile. *)
val move: animated -> unit
