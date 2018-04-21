type info = {species: string; speed: int; hp: int; damage: int}

    (*type mummy = |Normal of info|Conehead of info|Buckethead of info*)

(*type z_info = {info: info; hp: int}*)

(*type shooter = |Peashooter of info|Cactus of info*)

(*type p_info = {info: info; hp: int; freeze: float}*)

(* tile_lost defined only for leftmost tiles, which is set to true when a
   zombie has crossed the tile. *)
type tile = {x: int; y: int; size: int; mutable zombies: zombie list;
mutable plants: flora option; left: tile option; right: tile option;
mutable projectiles: projectile list; mutable tile_lost: bool option}

(*p_step initialized as 0 i.e. the left side of the tile *)
and projectile = {info: info; mutable p_pos: tile; mutable p_step: int;
mutable attacking: bool}

(* z_step initialized as size - 1 i.e. the right side of the tile *)
and zombie = {mummy: info; mutable z_pos: tile; mutable z_hp: int;
              mutable z_step: int; mutable attacked: bool; mutable z_attacking: bool;
             mutable frozen: int}

and plant = {shooter: info; tile: tile; mutable p_hp: int;
              mutable p_attacked: bool}

and flora = |Shooter of info |Sunflower of int

type item = |Zombie of zombie |Plant of plant
              |Projectile of projectile

type moving = |Projectile of projectile | Zombie of zombie

let plant f t = t.plants <- f

(* Updates the tile after removing zombie z from t.zombies *)
let remove_z t z = t.zombies <- List.filter (fun x -> x != z) t.zombies

(* Updates the tile after removing zombie z from t.zombies *)
let remove_p t p = t.projectiles <- List.filter (fun x -> x != p) t.projectiles

(* Updates the tile for any clash between the zombie and the projectile *)
let rec hit t =
  match t.projectiles with
  |[] -> ()
  |hdp::tlp -> let default_p = hdp in match t.zombies with
    |[] -> ()
    |hdz::tlz -> let default_z = hdz in
      (* leftmost zombie on the tile *)
      let leftmost = List.fold_left
          (fun default z -> if z.z_step < default.z_step then z else default)
          default_z t.zombies in
      (* rightmost projectile on the tile *)
      let rightmost = List.fold_left
          (fun default p -> if p.p_step > default.p_step then p else default)
          default_p t.projectiles in
      if leftmost.z_step > rightmost.p_step then ()
      else remove_p t rightmost;
      let next_hp = leftmost.z_hp - rightmost.info.damage in
      if next_hp > 0 then (leftmost.z_hp <- next_hp; hit t)
      else remove_z t leftmost; hit t

(* [move m] moves the object by its speed and bumps it to the next tile if
   necessary. *)
let move m = match m with
  |Projectile p -> begin let next_step = p.p_step + p.info.speed in
    let t = p.p_pos in
      if next_step < t.size then p.p_step <- next_step else
        remove_p t p;
      match t.right with
      |None -> ()
      |Some r -> p.p_pos <- r; p.p_step <- next_step mod t.size;
        r.projectiles <- p::(r.projectiles)  end
  |Zombie z -> let next_step = z.z_step - z.mummy.speed in
    let t = z.z_pos in
    if next_step >= 0 then z.z_step <- next_step else
      remove_z t z;
    match t.left with
    |None -> t.tile_lost <- Some true
    |Some l -> z.z_pos <- l; z.z_step <- next_step mod t.size;
      l.zombies <- z::(l.zombies)
