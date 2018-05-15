open Object
open Sprite

(* top_left = Cartesian coordinates of the top left corner of the stock panel.
   tiles    = tiles of the garden, containing the location and size of the tiles
              as well as the zombies, plants and projectiles present in the
              tile.
   sunlight = number of new sunlight.
   total    = total number of zombies to be released.
*)
type state = {
  top_left: int*int;
  tiles: (tile array) array;
  size: int;
  mutable sunlight: int;
  mutable total: int;
}

(* [ob] type is either a zombie, a plant, or a projectile. *)
type ob =
  |Zombie of zombie
  |Plant of plant
  |Projectile of projectile

(* [iter_matrix f t] applies function [f] to each tile in tile array array [t]. *)
let iter_matrix f tiles =
  Array.iter (fun row ->
      Array.iter (fun cell ->
          f cell)
    row) tiles

(* [init_state r c s (x,y) total] is the initial state with number of columns [c],
   number of rows [r], tile size [s], and coordinates [(x, y)] for top left
   corner, [total] the total number of zombies to be released.
   No plant, zombie or projectile is present on any of the tiles in the initial
   state. No sunlight is present in the garden either. *)
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

(* [update_tiles t] update all the information on every tile of tile array
   array [t].
*)
let update_tiles tiles =
  iter_matrix (fun cell -> hit cell) tiles;
  iter_matrix (fun cell -> hit_before_crossing cell) tiles;
  iter_matrix (fun cell ->
      List.iter (fun z -> move_z z) cell.zombies) tiles;
  iter_matrix (fun cell ->
          List.iter (fun p -> move_p p) cell.projectiles) tiles;
  iter_matrix (fun cell -> eat cell) tiles;
  iter_matrix (fun cell ->
      match cell.plant with
      |None -> ()
      |Some p -> grow p) tiles

(* [get_tile (x, y), st] returns the tile cooresponding to coordinates
   [x, y] in the state [st].
*)
let get_tile (x, y) st =
  let col = (x - (fst st.top_left))/st.size in
  let row = (y - (snd st.top_left))/st.size in
  st.tiles.(row).(col)

(* Updates the state with a new flora at coordinates (x, y)
   If the corresponding tile has tile.plant != None then do nothing.
   Requirs:
   String [s] represents a valid flora type id
   The (x, y) coordinats are within the boundary of the tiles array.
   Returns true if the plant has been planted, false otherwise (a plant
   is already on the tile or there are zombies on the tile)*)
let make_plant =
  let peashooter =
    {
      species = "peashooter";
      speed = 1;
      hp = 20;
      damage = 5;
      freeze = 1;
      full_growth = 15
    } in
  let sunflower =
  {
    species = "sunflower";
    speed = 0;
    hp = 50;
    damage = 0;
    freeze = 0;
    full_growth = 10
  } in
  fun id (x, y) st ->
    let max_x = fst st.top_left + (Array.length st.tiles.(0))*st.size in
    let max_y = snd st.top_left + (Array.length st.tiles)*st.size in
    let cur_x = x - (fst st.top_left) in
    let cur_y = y - (snd st.top_left) in
    try assert (cur_x >= 0 && cur_y >= 0 && cur_x < max_x && cur_y < max_y);
    let t = get_tile (x, y) st in
    match t.plant with
    |Some _ -> false
    |_ -> match t.zombies with |_::_ -> false |_ ->
      let x = t.x + t.size/2 in
      let y = t.y + t.size/2 in
      let crds = (float_of_int x, float_of_int y) in
      if id = "peashooter" then let species = peashooter in
        let p =
          {
            species = species;
            tile = t;
            p_hp = species.hp;
            attacked = false;
            growth = 0;
            p_sprite = to_sprite "peashooter" crds;
          } in
        plant (Some (Shooter p)) t; true
      else if id = "sunflower" then
        let p =
          {
            species = sunflower;
            tile = t;
            p_hp = sunflower.hp;
            attacked = false;
            growth = 0;
            p_sprite = to_sprite "sunflower" crds;
          } in
        t.plant <- Some (Sunflower {p = p; sunlight = false}); true
      else false
    with |_ -> false

(* Updates the state with a new zombie at coordinates (x, y), state.total -= 1
   Requirs:
   String [s] represents a valid zombie type id
   The (x, y) coordinats are within the boundary of the tiles array. *)
let make_zombie =
  let ocaml =
    {
      species = "ocaml";
      speed = 1;
      hp = 20;
      damage = 1;
      freeze = 0;
      full_growth = 0
    } in
  fun id (x, y) st ->
    let t = get_tile (x, y) st in
    if id = "ocaml" then let species = ocaml in
      let x = t.x + x - t.x in
      let y = t.y + t.size/2 in
      let crds = (float_of_int x,float_of_int y) in
      let z =
        {
          mummy = species;
          z_pos = t;
          z_hp = ocaml.hp;
          z_step = x - t.x;
          hit = false;
          is_eating = false;
          z_sprite = to_sprite "ocaml" crds;
        } in
      t.zombies <- z::t.zombies;
      st.total <- st.total - 1
    else ()

(* Returns the number of new sunlight produced by the state [st]. *)
let get_sunlight st = st.sunlight

(* Returns the type of the ob, i.e. type of mummy, type of
   flora, type of projectile, as a string id.
   "peashooter" for peashooter
   "sunflower" for sunflower
   "ocaml" for zombie *)
let get_type = function
  |Zombie z -> z.mummy.species
  |Plant p -> p.species.species
  |Projectile p -> p.name

(* [get_objects st] sweeps all the tiles in state [st] and returns all type ob
   in state [st] *)
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

(* Returns true if a zombie has crossed a leftmost tile *)
let has_lost st =
  let b = ref false in
  for i = 0 to Array.length st.tiles - 1 do
    b := !b || st.tiles.(i).(0).tile_lost;
  done;
  !b

(* Returns the coordinates of type ob *)
let get_coordinates = function
  |Zombie z ->
    let x = z.z_pos.x + z.z_step in
    let y = z.z_pos.y + z.z_pos.size/2 in
    (float_of_int x,float_of_int y)
  |Plant p ->
    let x = p.tile.x + p.tile.size/2 in
    let y = p.tile.y + p.tile.size/2 in
    (float_of_int x, float_of_int y)
  |Projectile p ->
    let x = p.p_pos.x + p.p_step in
    let y = p.p_pos.y + p.p_pos.size/2 in
    (float_of_int x, float_of_int y)

(* Returns true if total = 0 and there are no zombie on any tile *)
let has_won st =
  st.total <= 0 && not (has_lost st) &&
  Array.for_all (fun row ->
      Array.for_all (fun cell ->
          match cell.zombies with |[] -> true |_ ->false)
    row) st.tiles

(* [update_sprites obs] updates all the sprite fields of ob list [obs] *)
let update_sprites obs =
  let update_sprite ob =
    let crds = get_coordinates ob in
    (*print_float (fst crds);*)
    (*print_endline "X_coord";*)
    match ob with
    | Zombie z -> z.z_sprite.coords = crds;
    | Plant p -> p.p_sprite.coords = crds;
    | Projectile p -> p.sprite.coords = crds; in
  List.map update_sprite obs |> ignore;;

(* Update the state [st] by one move *)
let update st =
  st.sunlight <- 0;
  update_tiles st.tiles;
  get_objects st |> update_sprites;
  iter_matrix (fun cell ->
      match cell.plant with
      |None -> ()
      |Some p ->
        match p with
        |Sunflower {sunlight = b; _} when b = true ->
          st.sunlight <- st.sunlight + 1
        |_ -> ()) st.tiles

(* [print_state st] prints out all relevant information about state [st]. *)
let print_state st =
Array.iteri (fun i row ->
    Array.iteri (fun j cell ->
          print_endline ("tile: "^(string_of_int i)^", "^(string_of_int j));
          print_tile cell; print_endline "")
      row) st.tiles;
print_endline ("sunlight: "^(string_of_int st.sunlight));
print_endline ("total: "^(string_of_int st.total))
