open Object

type state = {
  top_left: int*int;
  tiles: (tile array) array;
  mutable sunlight: int;
  mutable total: int;
}

type objects = {zombies: zombie list; plants: plant list;
                projectiles: projectile list}

type character = |Z of zombie |P of plant

(* Applies function f to each element of the matrix *)
let iter_matrix f tiles =
  Array.iter (fun row ->
      Array.iteri (fun i cell ->
          f i cell)
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
  iter_matrix (fun i cell -> hit_before_crossing cell) tiles;
  iter_matrix 
