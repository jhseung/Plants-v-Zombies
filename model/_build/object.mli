(* Freeze and full_growth defined for plant and projectiles only.
   Freeze denotes the division by which
   speed is reduced to if hit by the projectile.
   full_growth represents the number of steps it take for the plant to unlock
   a certain capacity (e.g. producing sunlight) *)
type info = {species: string; speed: int; hp: int; damage: int;
             freeze: int option; full_growth: int option}

(*type mummy = |Normal of info|Conehead of info|Buckethead of info*)

(*type z_info = {info: info; hp: int}*)

(*type shooter = |Peashooter of info|Cactus of info*)

(*type p_info = {info: info; hp: int; freeze: float}*)

(* tile_lost defined only for leftmost tiles, which is set to true when a
   zombie has crossed the tile. *)
type tile = {x: int; y: int; size: int; mutable zombies: zombie list;
             mutable plant: flora option; mutable left: tile option; mutable right: tile option;
             mutable projectiles: projectile list; mutable tile_lost: bool option}

(*p_step initialized as 0 i.e. the left side of the tile *)
and projectile = {shooter: info; mutable p_pos: tile; mutable p_step: int}

(* z_step initialized as size - 1 i.e. the right side of the tile.
   is_eating set to true if there is flora on the same tile as the zombie *)
and zombie = {mummy: info; mutable z_pos: tile; mutable z_hp: int;
              mutable z_step: int; mutable hit: bool;
              (*mutable frozen: float*int;*)
              (* float represents the reduction in speed;
                 int represent the number of moves the freeze will last *)
              mutable is_eating: bool}

and plant = {species: info; tile: tile; mutable p_hp: int;
             mutable attacked: bool}

and flora = |Shooter of plant |Sunflower of plant

type item = |Zombie of zombie |Plant of plant
            |Projectile of projectile

type moving = |Projectile of projectile | Zombie of zombie


(* Plants a type of flora on tile
   requires: no zombie or flora is on the tile. *)
val plant: flora -> tile -> unit

(* Moves the moving object from the current tile to the next tile *)
(*val next_tile: moving -> unit*)

(* Update the step count of the moving object by one move (=speed)
If step >= tile.size, moves moving object to the next tile. *)
val move: moving -> unit

(* [hit_before_crossing r] updates the tile [r] to account for any collision
   between elements in r.zombies and elements in r.left.projectiles. *)
val hit_before_crossing: tile -> unit

(* [move_z z] updates z.tile to account for the movement of z *)
val move_z: zombie -> unit

(* [move_p z] updates p.tile to account for the movement of p *)
val move_p: projectile -> unit
