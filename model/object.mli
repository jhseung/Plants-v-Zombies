type info = {speed: int; hp: int}

type mummy = |Normal of info |Conehead of info |Buckethead of info 

type shooter = |Peashooter of info |Cactus of info

type projectile = {shooter: shooter; mutable tile: tile; mutable step: int}

type zombie = {mummy: mummy; mutable pos: tile; mutable hp: int; 
mutable step: int; mutable attacked: bool; mutable attacking: bool}

type moving = |Projectile of projectile | Zombie of zombie

type flora = |Shooter of shooter |Sunflower

type plant = {plant: shooter; mutable tile: tile; mutable hp: int; 
mutable attacked: bool}

(* Plants a type of flora on tile *)
val plant: flora -> tile -> unit

(* Moves the moving object from the current tile to the next tile *)
val next_tile: moving -> unit

(* Update the step count of the moving object by one move (=speed)
If step >= tile.size, moves moving object to the next tile. *)
val move: moving -> unit
