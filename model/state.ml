open Object

type state = {
  top_left: int*int;
  tiles: (tile array) array;
  size: int;
  mutable sunlight: int;
  mutable total: int;
}

type objects =
  |Zombie of zombie
  |Plant of plant
  |Projectile of projectile

type character =
  |Z of zombie
  |P of plant

(* Applies function f to each element of the matrix *)
let iter_matrix f tiles =
  Array.iter (fun row ->
      Array.iter (fun cell ->
          f cell)
    row) tiles

let init_state col row size (x_cord, y_cord) total =
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
        tile_lost = None
      }) in
  let init_matrix = Array.init row (fun i -> init_row i) in
  Array.iter (fun each_row ->
      Array.iteri (fun i cell ->
          if i > 0 then cell.left <- Some each_row.(i - 1)
          else cell.tile_lost <- Some false;
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
  st.tiles.(col).(row)

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
  fun id (x, y) st ->
    let t = get_tile (x, y) st in
    match t.plant with
    |Some _ -> ()
    |_ ->
      if id = "peashooter" then
        let p =
          {
            species = peashooter;
            tile = t;
            p_hp = peashooter.hp;
            attacked = false;
            growth = 0
          } in
        t.plant <- Some (Shooter p)
      else ()

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
    if id = "ocaml" then
      let z =
        {
          mummy = ocaml;
          z_pos = t;
          z_hp = ocaml.hp;
          z_step = x - t.x;
          hit = false;
          is_eating = false
        } in
      t.zombies <- z::t.zombies;
      st.total <- st.total - 1
    else ()
