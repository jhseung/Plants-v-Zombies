open Object

type state = {
  top_left: int*int;
  tiles: (tile array) array;
  size: int;
  mutable sunlight: int;
  mutable total: int;
}

type ob =
  |Zombie of zombie
  |Plant of plant
  |Projectile of projectile

type character =
  |Z of zombie
  |P of flora

(* Applies function f to each element of the matrix *)
let iter_matrix f tiles =
  Array.iter (fun row ->
      Array.iter (fun cell ->
          f cell)
    row) tiles

let init_state row col size (x_cord, y_cord) total =
  let rec init_row row_n = Array.init col (fun i ->
      {
        x = x_cord + i*size;
        y = y_cord + row_n*size;
        size = size;
        zombies = [];
        plant = None;
        left = None;
        right = None;
        projectiles = [];
        tile_lost = false
      }) in
  let init_matrix = Array.init row (fun i -> init_row i) in
  Array.iter (fun each_row ->
      Array.iteri (fun i cell ->
          if i > 0 then cell.left <- Some each_row.(i - 1)
          else ();
          if i < col - 1 then cell.right <- Some each_row.(i + 1)
          else ())
        each_row) init_matrix;
  {
    top_left = (x_cord, y_cord);
    tiles = init_matrix;
    size = size;
    sunlight = 0;
    total = total
  }

let update_tiles tiles =
  iter_matrix (fun cell -> hit_before_crossing cell) tiles;
  iter_matrix (fun cell ->
      List.iter (fun z -> move_z z) cell.zombies) tiles;
  Array.iter (fun row ->
      Array.fold_right (fun cell _ ->
          List.iter (fun p -> move_p p) cell.projectiles) row ()) tiles;
  iter_matrix (fun cell -> eat cell) tiles;
  iter_matrix (fun cell ->
      match cell.plant with
      |None -> ()
      |Some p -> grow p) tiles

let update st =
  st.sunlight <- 0;
  update_tiles st.tiles;
  iter_matrix (fun cell ->
      match cell.plant with
      |None -> ()
      |Some p ->
        match p with
        |Sunflower {sunlight = b; _} when b = true ->
          st.sunlight <- st.sunlight + 1
        |_ -> ()) st.tiles

let get_tile (x, y) st =
  let col = (x - (fst st.top_left))/st.size in
  let row = (y - (snd st.top_left))/st.size in
  st.tiles.(row).(col)

let make_plant =
  let peashooter =
    {
      species = "peashooter";
      speed = 5;
      hp = 5;
      damage = 1;
      freeze = 1;
      full_growth = 5
    } in
  let sunflower =
  {
    species = "sunflower";
    speed = 0;
    hp = 5;
    damage = 0;
    freeze = 0;
    full_growth = 10
  } in
  fun id (x, y) st ->
    let t = get_tile (x, y) st in
    match t.plant with
    |Some _ -> false
    |_ -> match t.zombies with |_::_ -> false |_ ->
      if id = "peashooter" then let species = peashooter in
        let p =
          {
            species = species;
            tile = t;
            p_hp = species.hp;
            attacked = false;
            growth = 0
          } in
        plant (Shooter p) t; true
      else if id = "sunflower" then
        let p =
          {
            species = sunflower;
            tile = t;
            p_hp = sunflower.hp;
            attacked = false;
            growth = 0
          } in
        t.plant <- Some (Sunflower {p = p; sunlight = false}); true
      else false

let make_zombie =
  let ocaml =
    {
      species = "ocaml";
      speed = 1;
      hp = 5;
      damage = 1;
      freeze = 0;
      full_growth = 0
    } in
  fun id (x, y) st ->
    let t = get_tile (x, y) st in
    if id = "ocaml" then let species = ocaml in
      let z =
        {
          mummy = species;
          z_pos = t;
          z_hp = ocaml.hp;
          z_step = x - t.x;
          hit = false;
          is_eating = false
        } in
      t.zombies <- z::t.zombies;
      st.total <- st.total - 1
    else ()

let get_sunlight st = st.sunlight

let get_type = function
  |Zombie z -> z.mummy.species
  |Plant p -> p.species.species
  |Projectile p -> p.shooter.species

let get_objects st =
  Array.fold_left (fun acc_row row -> acc_row@
      (Array.fold_left (fun acc cell ->
          let plant = match cell.plant with
            |None -> []
            |Some (Shooter p) |Some (Sunflower {p = p; _}) -> [Plant p] in
          let zombies = List.map (fun z -> Zombie z) cell.zombies in
          let projectiles = List.map (fun p -> Projectile p) cell.projectiles in
          plant@zombies@projectiles@acc)
         [] row)) [] st.tiles

let has_lost st =
  let b = ref false in
  for i = 0 to Array.length st.tiles - 1 do
    b := !b || st.tiles.(i).(0).tile_lost;
  done;
  !b

let get_coordinates = function
  |Zombie z ->
    let x = z.z_pos.x + z.z_step in
    let y = z.z_pos.y + z.z_pos.size/2 in
    (x, y)
  |Plant p ->
    let x = p.tile.x + p.tile.size/2 in
    let y = p.tile.y + p.tile.size/2 in
    (x, y)
  |Projectile p ->
    let x = p.p_pos.x + p.p_step in
    let y = p.p_pos.y + p.p_pos.size/2 in
    (x, y)

let has_won st =
  st.total <= 0 && not (has_lost st) &&
  Array.for_all (fun row ->
      Array.for_all (fun cell ->
          match cell.zombies with |[] -> true |_ ->false)
    row) st.tiles
