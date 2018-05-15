open Sprite
(* Freeze and full_growth defined for plant and projectiles only.
   Freeze denotes the division by which
   speed is reduced to if hit by the projectile.
   full_growth represents the number of steps it take for the plant to unlock
   a certain capacity (e.g. producing sunlight) *)
type info =
  {
    species: string;
    speed: int;
    hp: int;
    damage: int;
    freeze: int;
    full_growth: int
  }

(*type mummy = |Normal of info|Conehead of info|Buckethead of info*)

(*type z_info = {info: info; hp: int}*)

(*type shooter = |Peashooter of info|Cactus of info*)

(*type p_info = {info: info; hp: int; freeze: float}*)

(* t.x and t.y represents the coordinates of the top left corner of t
   t.tile_lost set to true if the t.left = None && a zombie has passed through
   the left side of t. *)
type tile =
  {
    x: int;
    y: int;
    size: int;
    mutable zombies: zombie list;
    mutable plant: flora option;
    mutable left: tile option;
    mutable right: tile option;
    mutable projectiles: projectile list;
    mutable tile_lost: bool
  }

(*p_step initialized as 0 i.e. the left side of the tile *)
and projectile = {
                  shooter: info;
                  mutable p_pos: tile;
                  mutable p_step: int;
                  name: string;
                  mutable sprite: sprite;
                  }

(* z_step initialized as size - 1 i.e. the right side of the tile.
   is_eating set to true if there is flora on the same tile as the zombie *)
and zombie = {
              mummy: info;
              mutable z_pos: tile;
              mutable z_hp: int;
              mutable z_step: int;
              mutable hit: bool;
              (*mutable frozen: float*int;*)
(* float represents the reduction in speed; int represent the number of moves the freeze will last *)
              mutable is_eating: bool;
              mutable z_sprite: sprite;
              }

and plant = {
              species: info;
              tile: tile;
              mutable p_hp: int;
              mutable attacked: bool;
              mutable growth: int;
              mutable p_sprite: sprite;
              }


and sunflower =  {p: plant; mutable sunlight: bool}

and flora =
  |Shooter of plant
  |Sunflower of sunflower

(*type item = |Zombie of zombie |Plant of plant
            |Projectile of projectile*)


(* Plants a type of flora on tile
   requires: no zombie or flora is on the tile. *)
val plant: flora option -> tile -> unit

(* Moves the moving object from the current tile to the next tile *)
(*val next_tile: moving -> unit*)

(* [hit_before_crossing r] updates the tile [r] to account for any collision
   between elements in r.zombies and elements in r.left.projectiles. *)
val hit_before_crossing: tile -> unit

(* [hit t] updates tile [t] to account for any clash between the zombies and
   the projectiles on tile [t]. *)
val hit: tile -> unit

(* [move_z z] updates z.tile to account for the movement of z *)
val move_z: zombie -> unit

(* [move_p z] updates p.tile to account for the movement of p *)
val move_p: projectile -> unit

(* [eat t] updates t to account for any collision between elements in t.zombies
   and t.plant *)
val eat: tile -> unit

(* [grow p] increments the growth of p. If p has reached full growth, makes a
   projectile if p is a shooter, sets p.sunlight to true if p is a sunflower,
   which is set to false otherwise. *)
val grow: flora -> unit

(* [print_tile t] prints out all relevant information about tile [t]. *)
val print_tile: tile -> unit