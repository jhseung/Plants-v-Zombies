(* TODO: freeze
   TODO: chagen steps to floats\
   TODO: speed up
   TODO: make projectile & shooter growth
   TODO: dead: (object*int) list
   TODO: growth: int: growth + 1 mod full and add sunlight if = full - 1*)

(* Freeze and full_growth defined for plant and projectiles only.
   Freeze denotes the division by which
   speed is reduced to if hit by the projectile.
   full_growth represents the number of steps it take for the plant to unlock
   a certain capacity (e.g. producing projectile, producing sunlight) *)
type info =
  {
    species: string;
    speed: int;
    hp: int;
    damage: int;
    freeze: int;
    full_growth: int
  }

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
and projectile =
  {
    shooter: info;
    mutable p_pos: tile;
    mutable p_step: int
  }

(* z_step initialized as size - 1 i.e. the right side of the tile.
  is_eating set to true if there is flora on the same tile as the zombie *)
and zombie =
  {
    mummy: info;
    mutable z_pos: tile;
    mutable z_hp: int;
    mutable z_step: int;
    mutable hit: bool;
              (*mutable frozen: float*int;*)
(* float represents the reduction in speed;
   int represent the number of moves the freeze will last *)
    mutable is_eating: bool
  }

and plant =
  {
    species: info;
    tile: tile;
    mutable p_hp: int;
    mutable attacked: bool;
    mutable growth: int
  }


and sunflower =  {p: plant; mutable sunlight: bool}

and flora =
  |Shooter of plant
  |Sunflower of sunflower


(*type item = |Zombie of zombie |Plant of plant
              |Projectile of projectile*)

let plant f t = t.plant <- f

(* Updates the tile after removing zombie z from t.zombies *)
let remove_z t z =
  t.zombies <- List.filter (fun x -> x != z) t.zombies

(* Updates the tile after removing zombie z from t.zombies *)
let remove_p t p =
  t.projectiles <- List.filter (fun x -> x != p) t.projectiles

let hit_z projectile zombie tile_l tile_r =
  remove_p tile_l projectile;
  let next_hp = zombie.z_hp - projectile.shooter.damage in
  if next_hp > 0 then (zombie.z_hp <- next_hp; zombie.hit <- true;)
  else remove_z tile_r zombie

let rightmost_p tile default =
  List.fold_left
    (fun default p -> if p.p_step > default.p_step then p else default)
    default tile.projectiles

let leftmost_z tile default =
  List.fold_left
    (fun default z -> if z.z_step < default.z_step then z else default)
    default tile.zombies

(* Assumes that crossing only occurs between adjacent tiles
   Applied before move to check for collisions that could be missed when
   crossing the tile on the left
   Find rightmost projectile on l and leftmost projectile on r and if there are
   zombies between them then () else check and whether
   distance < p.speed + z.speed *)
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
        else hit_z rightmost leftmost l r; hit_before_crossing r

(* Updates the tile for any clash between the zombie and the projectile *)
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
      if leftmost.z_step > rightmost.p_step then ()
      else hit_z rightmost leftmost t t; hit t

let eat t =
  match t.plant with
  |None -> ()
  |Some f -> match f with
    |Shooter p |Sunflower {p = p; _} ->
      match t.zombies with
      |[] -> p.attacked <- false
      |hd::tl -> p.attacked <- true;
        let next_hp = List.fold_left (fun acc z -> z.is_eating <- true;
                                       acc - z.mummy.damage) p.p_hp t.zombies in
        p.p_hp <- next_hp;
        if next_hp > 0 then ()
        else (t.plant <- None;
              List.fold_left (fun acc z -> z.is_eating <- false) () t.zombies)

(* Must be called from leftmost tile to the right *)
let move_z z = z.hit <- false;
  if z.is_eating = true then ()
  else (*let speed = int_of_float (fst z.frozen) * z.mummy.speed in
         snd z.frozen <- snd z.frozen - 1;*)
    let next_step = z.z_step - z.mummy.speed in
    let t = z.z_pos in
  if next_step >= 0 then z.z_step <- next_step
  else (remove_z t z;
  match t.left with
  |None -> begin t.tile_lost <- true end
  |Some l ->
    z.z_pos <- l;
    z.z_step <- (next_step + l.size) mod t.size;
    l.zombies <- z::(l.zombies))

(* Must be called from rightmost tile to the left *)
let move_p p =
  let next_step = p.p_step + p.shooter.speed in
  let t = p.p_pos in
    if next_step < t.size then p.p_step <- next_step
    else remove_p t p;
    match t.right with
    |None -> ()
    |Some r ->
      p.p_pos <- r;
      p.p_step <- next_step mod t.size;
      r.projectiles <- p::(r.projectiles)

(* Assume that projectile originates from the center of the tile *)
let make_projectile p =
  let pea =
    {
      shooter = p.species;
      p_pos = p.tile;
      p_step = p.tile.size/2
    } in
  p.tile.projectiles <- pea::p.tile.projectiles

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

let print_coordinates t =
  print_endline ("(x, y): "^(string_of_int t.x)^", "^(string_of_int t.y))

let print_plant p =
  print_endline ("species: "^(p.species.species));
  print_coordinates p.tile;
  print_endline ("hp: "^(string_of_int p.p_hp));
  print_endline ("being attacked: "^(string_of_bool p.attacked));
  print_endline ("growth: "^(string_of_int p.growth))

let print_zombie z =
  print_endline ("species: "^(z.mummy.species));
  print_coordinates z.z_pos;
  print_endline ("hp: "^(string_of_int z.z_hp));
  print_endline ("step: "^(string_of_int z.z_step));
  print_endline ("being hit: "^(string_of_bool z.hit));
  print_endline ("is eating: "^(string_of_bool z.is_eating))

let print_projectile p =
  print_endline ("species: "^(p.shooter.species));
  print_coordinates p.p_pos;
  print_endline ("step: "^(string_of_int p.p_step))

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
