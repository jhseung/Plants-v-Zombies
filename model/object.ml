open Sprite

(* [info] defines the immutable features associated with an object. *)
type info =
  {
    species: string;
    speed: int;
    hp: int;
    damage: int;
    freeze: int;
    full_growth: int
  }

(* [tile] type contains the information about the current tile, including its
   cooridnates, size, the objects currently on the tile, and its neighbors.
   [tile.tile_lost] is set to true only if it's the leftmost tile and a
   zombie has crossed the tile
*)
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

(* [projectile] type contains the information about a projectile, including its
   immutable features, the tile it's currently on, and its position relative to
   the tile.
*)
and projectile =
  {
    shooter: info;
    mutable p_pos: tile;
    mutable p_step: int;
    name: string;
    mutable sprite: sprite;
  }

(* [zombie] type contains the information about a zombie, including its
   immutable features, the tile it's currently on, and its position relative to
   the tile.
*)
and zombie =
  {
    mummy: info;
    mutable z_pos: tile;
    mutable z_hp: int;
    mutable z_step: int;
    mutable hit: bool;
    mutable is_eating: bool;
    mutable z_sprite: sprite;
  }

(* [plant] type contains the information about a plant, including its
   immutable features, the tile it's currently on, and its position relative to
   the tile.
   [plant.growth] is incremented during each update and resets when it makes
   a projectile/sunlight.
*)
and plant =
  {
    species: info;
    tile: tile;
    mutable p_hp: int;
    mutable attacked: bool;
    mutable growth: int;
    mutable p_sprite: sprite;
  }

(* [sunflower] type contains the information about a sunflower with infomation
   about its plant and whether it is producing any sunlight.
*)
and sunflower =  {p: plant; mutable sunlight: bool}

(* [flora] type is either a shooter type or a sunflower type *)
and flora =
  |Shooter of plant
  |Sunflower of sunflower

(* Plants a type of flora on tile
   requires: no zombie or flora is on the tile. *)
let plant f t = t.plant <- f

(* Updates the tile after removing zombie z from t.zombies *)
let remove_z t z =
  t.zombies <- List.filter (fun x -> x != z) t.zombies

(* Updates the tile after removing zombie z from t.zombies *)
let remove_p t p =
  t.projectiles <- List.filter (fun x -> x != p) t.projectiles

(* [hit_before_crossing p z l r] updates tile [l] and tile [r] to account for the
   collision between projectile [p] and zombie [z]. *)
let hit_z projectile zombie tile_l tile_r =
  remove_p tile_l projectile;
  (let next_hp = zombie.z_hp - projectile.shooter.damage in
  if next_hp > 0 then (zombie.z_hp <- next_hp; zombie.hit <- true;)
  else remove_z tile_r zombie)

(* [rightmost_p t d] returns the rightmost projectile on tile [t]. *)
let rightmost_p tile default =
  List.fold_left
    (fun default p -> if p.p_step > default.p_step then p else default)
    default tile.projectiles

(* [leftmost_z t d] returns the leftmost zombie on tile [t]. *)
let leftmost_z tile default =
  List.fold_left
    (fun default z -> if z.z_step < default.z_step then z else default)
    default tile.zombies

(* [hit_before_crossing r] updates the tile [r] to account for any collision
   between elements in r.zombies and elements in r.left.projectiles. *)
let rec hit_before_crossing r =
  match r.left with
  |None -> ()
  |Some l ->
  match l.projectiles with
  |[] -> ()
  |hdp::tlp ->
    match r.zombies with
    |[] -> ()
    |hdz::tlz ->
      let default_p = hdp in
      let rightmost = rightmost_p l default_p in
      (* Exists zombies between the rightmost projectile on l and tile r *)
      if List.exists (fun z -> z.z_step > rightmost.p_step) l.zombies then ()
      else let default_z = hdz in
        let leftmost = leftmost_z r default_z in
        if l.size - rightmost.p_step + leftmost.z_step
           > rightmost.shooter.speed + leftmost.mummy.speed then ()
        else (hit_z rightmost leftmost l r; hit_before_crossing r)

(* [hit t] updates tile [t] to account for any clash between the zombies and
   the projectiles on tile [t]. *)
let rec hit t =
  match t.projectiles with
  |[] -> ()
  |hdp::tlp ->
    let default_p = hdp in match t.zombies with
    |[] -> ()
    |hdz::tlz -> let default_z = hdz in
      (* leftmost zombie on the tile *)
      let leftmost = leftmost_z t default_z in
      (* rightmost projectile on the tile *)
      let rightmost = rightmost_p t default_p  in
      if leftmost.z_step - leftmost.mummy.speed
         > rightmost.p_step +  rightmost.shooter.speed then ()
      else (hit_z rightmost leftmost t t; hit t)

(* [eat t] updates t to account for any collision between elements in t.zombies
   and t.plant *)
let eat t =
  match t.plant with
  |None -> ()
  |Some f -> match f with
    |Shooter p |Sunflower {p = p; _} ->
      match t.zombies with
      |[] -> p.attacked <- false
      |hd::tl -> p.attacked <- true;
        let next_hp = List.fold_left
            (fun acc z -> z.is_eating <- true;
              acc - z.mummy.damage) p.p_hp t.zombies in
        p.p_hp <- next_hp;
        if next_hp > 0 then ()
        else (t.plant <- None;
              List.fold_left
                (fun acc z -> z.is_eating <- false) () t.zombies)

(* [move_z z] updates z.tile to account for the movement of z *)
let move_z z = z.hit <- false;
  if z.is_eating = true then ()
  else
    let next_step = z.z_step - z.mummy.speed in
    let t = z.z_pos in
    if next_step >= 0 then (z.z_step <- next_step;
    let x = z.z_pos.x + z.z_step in
    let y = z.z_pos.y + z.z_pos.size/2 in
    z.z_sprite.coords <- (float_of_int x, float_of_int y))
  else (remove_z t z;
  match t.left with
  |None -> begin t.tile_lost <- true end
  |Some l ->
    z.z_pos <- l;
    z.z_step <- (next_step + l.size) mod t.size;
    let x = z.z_pos.x + z.z_step in
    let y = z.z_pos.y + z.z_pos.size/2 in
    z.z_sprite.coords <- (float_of_int x, float_of_int y);
    l.zombies <- z::(l.zombies))

(* [move_p z] updates p.tile to account for the movement of p *)
let move_p p =
  let next_step = p.p_step + p.shooter.speed in
  let t = p.p_pos in
  if next_step < t.size then (p.p_step <- next_step;
  let x = p.p_pos.x + p.p_step in
  let y = p.p_pos.y + p.p_pos.size/2 in
  p.sprite.coords <- (float_of_int x, float_of_int y))
    else remove_p t p;
    (match t.right with
    |None -> ()
    |Some r ->
      p.p_pos <- r;
      p.p_step <- next_step mod t.size;
      let x = p.p_pos.x + p.p_step in
      let y = p.p_pos.y + p.p_pos.size/2 in
      p.sprite.coords <- (float_of_int x, float_of_int y);
      r.projectiles <- p::(r.projectiles))

(* [make_projectile p] creates a new projectile originating from plant [p]. *)
let make_projectile p =
let x = p.tile.x + p.tile.size/2 in
let y = p.tile.y + p.tile.size/2 in
let crds = (float_of_int x, float_of_int y) in
let pea =
  {
    shooter = p.species;
    p_pos = p.tile;
    p_step = p.tile.size/2;
    name = "projectile";
    sprite = to_sprite "projectile" crds;
  } in
  p.tile.projectiles <- pea::p.tile.projectiles

(* [grow p] increments the growth of p. If p has reached full growth, makes a
   projectile if p is a shooter, sets p.sunlight to true if p is a sunflower,
   which is set to false otherwise. *)
let grow p =
  match p with
  |Shooter s -> begin
      s.growth <- (s.growth + 1) mod s.species.full_growth;
    if s.growth = 0 then make_projectile s
    else () end
  |Sunflower s ->
    s.p.growth <- (s.p.growth + 1) mod s.p.species.full_growth;
    if s.p.growth = 0 then s.sunlight <- true
    else s.sunlight <- false

(* [print_coordinates t] prints the coordiantes of tile [t]. *)
let print_coordinates t =
  print_endline ("(x, y): "^(string_of_int t.x)^", "^(string_of_int t.y))

(* [print_plant p] prints out all relevant information about plant [p]. *)
let print_plant p =
  print_endline ("species: "^(p.species.species));
  print_coordinates p.tile;
  print_endline ("hp: "^(string_of_int p.p_hp));
  print_endline ("being attacked: "^(string_of_bool p.attacked));
  print_endline ("growth: "^(string_of_int p.growth))

(* [print_zombie z] prints out all relevant information about zombie [z]. *)
let print_zombie z =
  print_endline ("species: "^(z.mummy.species));
  print_coordinates z.z_pos;
  print_endline ("hp: "^(string_of_int z.z_hp));
  print_endline ("step: "^(string_of_int z.z_step));
  print_endline ("being hit: "^(string_of_bool z.hit));
  print_endline ("is eating: "^(string_of_bool z.is_eating))

(* [print_projectile p] prints out all relevant information about projectile
   [p]. *)
let print_projectile p =
  print_endline ("projectile species: "^(p.shooter.species));
  print_coordinates p.p_pos;
  print_endline ("step: "^(string_of_int p.p_step))

(* [print_tile t] prints out all relevant information about tile [t]. *)
let print_tile t =
  print_coordinates t;
  List.iter (fun z -> print_zombie z; print_endline "") t.zombies;
  (match t.plant with
  |Some (Shooter p) -> print_plant p
  |Some (Sunflower {p = p; sunlight = b})
    -> print_plant p; print_endline (string_of_bool b)
  |_ -> ());
  (match t.left with
  |Some l -> print_string "left tile: ";print_coordinates l
  |_ -> ());
  (match t.right with
  |Some r -> print_string "right tile: ";print_coordinates r
  |_ -> ());
    List.iter (fun p -> print_projectile p) t.projectiles;
    print_endline ("tile is lost: "^(string_of_bool t.tile_lost))
