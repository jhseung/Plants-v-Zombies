open Object

type state = {
  top_left: int*int;
  tiles: (tile array) array;
  mutable sunlight: int;
  mutable total: int;
}

type objects = |Zombie of zombie |Plant of plant |Projectile of projectile

type character = |Z of zombie |P of plant

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
          if i < col - 1 then cell.right <- Some each_row.(i + 1) else ())
        each_row) init_matrix;
{
  top_left = (x_cord, y_cord);
  tiles = init_matrix;
  sunlight = 0;
  total = total
}

let update_tiles tiles =
  iter_matrix (fun cell -> hit_before_crossing cell) tiles;
  iter_matrix (fun cell ->
      List.iter (fun z -> move_z z) cell.zombies) tiles;
  Array.iter (fun row ->
      Array.fold_right (fun cell _ ->
          List.iter (fun p -> move_p p) cell.projectiles) row ()) tiles
