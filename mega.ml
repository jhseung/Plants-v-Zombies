open State
open Sprite

(*name of flora type : peashooter, sunflower*)
type flora_t = string

(*name of zombie type : ocaml*)
type zombie_t = string

(*type that includes all the information of the status of the game, referred to
  as the mega state.
  col = number of columns of tiles.
  row = number of rows of tiles.
  sun = a 2D array whose entry corresponds to each tile, [sun.(c).(r)] is [None]
        if there is no sunlight in the tile at column [c] and row [r] and it is
        [Some age] if there is sunlight in that tile and it has been there for
        [age] steps.
  sun_bal = sun balance, the amount of collected sunlight that has not been used
            by the program to add flora to the stock.
  num_tiles_wout_sun = number of tiles where there is no sunlight.
  stock = list of flora in stock, the entry [(f, s, n)] of the list represents
          that there are a number ([n]) of flora of type [f] in the stock, and
          the flora of type [f] is selected by the player iff [s] is true.
  st = the state of the garden, i.e. positions and health points of flora and
       zombies in the garden. See state.mli for more details.
*)
type mega = {
  col : int;
  row : int;
  sun : int option array array;
  sun_bal : int;
  num_tiles_wout_sun : int;
  stock : (flora_t * bool * int) list;
  mutable st : state;
  sprite_list: sprite list;
}

let init_mega c r size (x, y) total =
  {
    col = c;
    row = r;
    sun = Array.make_matrix c r None;
    sun_bal = 0;
    num_tiles_wout_sun = c * r;
    stock = ["sunflower", false, 1; "peashooter", false, 0];
    st = init_state r c size (x, y) total;
    sprite_list = [];
  }

let tile_of_coord (x, y) m =
  let (x0,y0) = (m.st).top_left in
  let c = (x - x0) / (m.st).size in
  let r = (y - y0) / (m.st).size in
  if c >= 0 && c < m.col && r >=0 && r < m.row then Some (c, r)
  else None

let sunlight_of_tile (c, r) m = m.sun.(c).(r)

(*[change_sun_bal amount m] is the mega state after the sun balance of mega
  state [m] has changed by [amount].*)
let change_sun_bal amount m = {m with sun_bal = max 0 (m.sun_bal + amount)}

(*[remove_sunlight (c, r) m] is the mega state after the sunlight in the tile
  at column [c] and row [r] has been removed in mega state [m].*)
let remove_sunlight (c, r) m =
  m.sun.(c).(r) <- None;
  let n = m.num_tiles_wout_sun in
  {m with num_tiles_wout_sun = n + 1}

(*[next_entry_of_matrix (c, r) col row] is the indices of entry after [(c, r)]
  in a column-major matrix with [col] columns and [row] rows.*)
let next_entry_of_matrix (c, r) col row =
  if r < row - 1 then (c, r + 1)
  else if c < col - 1 then (c + 1, 0)
  else failwith "Next entry does not exist in matrix."

(*[nth_tile_wout_sun n (c,r) m] is the position (in terms of (column, row)) of
  the [n]-th tile counting the tile at [(c,r)] as the 0-th tile (counting in a
  column-major fashion) in the mega state [m].*)
let rec nth_tile_wout_sun n (c, r) m =
  let co = m.col in
  let ro = m.row in
  match (n, m.sun.(c).(r)) with
  | (0, None) -> (c, r)
  | (n, None) -> nth_tile_wout_sun (n-1) (next_entry_of_matrix (c, r) co ro) m
  | (n, Some _) -> nth_tile_wout_sun n (next_entry_of_matrix (c, r) co ro) m

(*[create_one_sunlight m] creates one sunlight at a random tile that does not
  already have a sunlight in the mega state [m], and returns the new mega state.
  requires: there is at least one tile where there is not sunlight.
*)
let create_one_sunlight m =
  let space = m.num_tiles_wout_sun in
  let n = Random.int space in
  let (c, r) = nth_tile_wout_sun n (0,0) m in
  m.sun.(c).(r) <- Some 0;
  {m with num_tiles_wout_sun = space - 1}

(*[create_sunlights num m] creates a number of [num] sunlights in the mega state
  [m] and returns the resulting mega state. If the number of tiles without
  sunlight in [m] is less than [num], then it fills all the tiles with
  sunlights. It ensures that there is at most one sunlight in every tile.*)
let rec create_sunlights num m =
  let to_create = min num (m.num_tiles_wout_sun) in
  if to_create <= 0 then m
  else create_one_sunlight m |> create_sunlights (num - 1)

(*[shed_sunlight m] creates an amount of sunlight according to the number of
  sunflowers present in the garden in mega state [m], within the constraint that
  there is as most one sunlight in every tile, and returns the new mega state.*)
let shed_sunlight m =
  create_sunlights (get_sunlight m.st) m

let collect_sunlight (c,r) m =
    change_sun_bal 50 m |> remove_sunlight (c,r)

(*the number of steps for which a sunlight can be there before it disappears*)
let life_span_of_sunlight = 5

(*[dissipate_sunlight_col sun_col acc] adds 1 to each entry of the 1D array
  [sun_col] if that entry is less than [life_span_of_sunlight], makes the entry
  [None] if it is not less than [life_span_of_sunlight], and returns the altered
  1D array. Every time it makes an entry [None] it also increments [acc] by 1.
*)
let dissipate_sunlight_col sun_col acc =
  Array.map
    (fun x -> match x with
       | Some age -> if age < life_span_of_sunlight then Some (age + 1)
         else (acc := !acc + 1; None)
      | None -> None)
    sun_col

(*[dissipate_sunlight m] increases the age of each sunlight in mega state [m] by
  1 and removes the sunlights as old as [life_span_of_sunlight], and returns the
  new mega state.
*)
let dissipate_sunlight m =
  let acc = ref m.num_tiles_wout_sun in
  let sun' = Array.map (fun x -> dissipate_sunlight_col x acc) m.sun in
  {m with sun = sun'; num_tiles_wout_sun = !acc}

(*[same f1 f2] is true iff f1 and f2 are the same type of flora. *)
let same f1 f2 = f1 = f2

let get_num_in_stock f m =
  let (f'', s'', n'') = List.find (fun (f',s',n') -> same f f') m.stock in
  n''

let select_flora_in_stock f selected m =
  let stk = List.map
    (fun (f',s',n') -> if same f f' then (f',selected,n') else (f',s',n'))
    m.stock
  in {m with stock = stk}

(*[change_stock f n stk] is the updated stock after the number of flora of type
  [f] has been changed by [n] in the stock [stk]. If [n] is positive then flora
  are added and otherwise taken away. *)
let change_stock f n stk =
  List.map
    (fun (f',s',n') -> if same f f' then (f',s',n' + n) else (f',s',n'))
    stk

(*maximum price of a single flora.*)
let max_price = 100

(*number of species of flora.*)
let n_species = 2

(*[price f] is the price of a single flora of type [f].*)
let price f =
  match f with
  | "peashooter" -> 100
  | "sunflower" -> 50
  | _ -> failwith "unavailable flora in \'price\'"

(*[flora_of_int i] is the flora type mapped to integer [i].*)
let flora_of_int i =
  match i with
  | 0 -> "peashooter"
  | 1 -> "sunflower"
  | _ -> failwith "integer not mapped to any flora"

(*[buy_flora bal stk] is [(bal',stk')] where [bal'] is the remaining balance and
  [stk'] is the replenished stock after flora has been bought with a balance of
  [bal] and the stock before the purchase being [stk]. The sunlights are the
  currency and the purchase is determined entirely by the game instead of the
  player. The program determines which flora to buy in a random manner and keeps
  buying until the balance is not greater than [max_price].*)
let rec buy_flora bal stk =
  if bal <= max_price then (bal, stk)
  else
    let f = Random.int n_species |> flora_of_int in
    let p = price f in
    if p <= bal then buy_flora (bal - p) (change_stock f 1 stk)
    else buy_flora bal stk

(*[add_to_stock m] adds unspecified types and number of flora to the stock in
  [m] and decreases the sunlight balance accordingly to return the new mega
  state.*)
let add_to_stock m =
  let (bal, stk) = buy_flora m.sun_bal m.stock in
  {m with sun_bal = bal; stock = stk}

let plant_a_flora f (x,y) m =
  if make_plant f (x,y) m.st then
    let stk = m.stock in
    let m' = {m with stock = change_stock f (-1) stk}
             |> select_flora_in_stock f false in
    (true, m')
  else (false, m)

(*[distinct_rand max_num r lst] is a list of distinct random numbers in 0, 1,
  ..., r-1, with the length of the list also random but not greater than
  [max_num].
  requires : max_num <= r.
*)
let rec distinct_rand max_num r lst =
  if max_num <= 0 then lst
  else let rand = Random.int r in
    if List.mem rand lst then lst
    else distinct_rand (max_num - 1) r (rand::lst)

(*[add_zombie m] decides whether to let more zombies enter the garden and from
  which lane(s) they enter, and if yes then adds the zombie(s) on the right edge
  of the garden and returns the new mega state, otherwise returns [m].*)
let add_zombie m =
  let (x0, y0) = m.st.top_left in
  let size = m.st.size in
  let edge = x0 + m.st.size * m.col - 1 in
  let lst = distinct_rand (min m.row m.st.total) m.row [] in
  List.iter (fun r -> make_zombie "ocaml" (edge, r * size + size / 2) m.st) lst;
  m

let update_mega =
  let counter = ref 0 in
  fun m -> update m.st; counter := !counter + 1;
    let m' = dissipate_sunlight m |> add_to_stock |> add_zombie in
    match !counter with
    | 1 -> shed_sunlight m'
    | 5 -> counter := 0; m'
    | _ -> m'
