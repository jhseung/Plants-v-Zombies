type mummy = |Normal |Conehead |Buckethead

type z_info = {mummy: mummy; speed: int; hp: int}

type shooter = |Peashooter |Cactus

type p_info = {shooter: shooter; speed: int; hp: int; freeze: float}

type tile = {x: int; y: int; size: int; mutable zombies: zombie list;
mutable plant: plant option; left: tile; right: tile;
mutable projectiles: projectile list}

and projectile = {shoot: shooter; mutable tile: tile; mutable p_step: int;
mutable attacking: bool}

and zombie = {mummy: z_info; mutable z_pos: tile; mutable z_hp: int;
              mutable z_step: int; mutable attacked: bool; mutable z_attacking: bool;
             mutable frozen: int option}

and plant = {shooter: p_info; mutable p_pos: tile; mutable p_hp: int;
              mutable p_attacked: bool}

type flora = |Shooter of p_info |Sunflower

type item = |Zombie of zombie |Plant of plant
              |Projectile of projectile

type moving = |Projectile of projectile | Zombie of zombie

(*position of sunlight and number of time steps since created*)
type sunlight = {pos : int*int; age : int}

(* Plants a type of flora on tile
   requires: no zombie is on the tile. *)
val plant: flora -> tile -> unit

(* Moves the moving object from the current tile to the next tile *)
val next_tile: moving -> unit

(* Update the step count of the moving object by one move (=speed)
If step >= tile.size, moves moving object to the next tile. *)
val move: moving -> unit
