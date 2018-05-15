open Mega

(*type of the mouse click.
  [Cstart] represents a click on the start button.
  [Cgarden (x,y)] represents a click on coordinates [(x,y)].
  [Cstock f] represents a click on the flora of type [f] in the stock panel.*)
type clicked = Cstart | Cgarden of float*float | Cstock of flora_t

(*[print_clicked c] print the parsed mouse click [c].*)
let print_clicked c =
  match c with
  | Cstart -> print_endline "start"
  | Cgarden (x,y) -> "garden "^(string_of_float x)^","^(string_of_float y)
                     |> print_endline
  | Cstock f -> "stock "^f |> print_endline

(*[round_pos x] rounds a non-negative float [x] to its nearest integer and
  returns that integer.*)
let round_pos x =
  let trunc = int_of_float x in
  if (x -. float_of_int trunc) > 0.5 then 1 + trunc
  else trunc;;

(*[round x] rounds a float [x] to its nearest integer and returns that integer.
*)
let round x =
  if x >= 0.0 then round_pos x
  else ~- (round_pos (~-.x));;

(*[plant_flora_helper f (x,y) prev curr m] returns [prev',curr], where [f] is
  a flora type that has been selected in the stock panel and waits to be
  planted and [prev] is the mouse click that made this selection, [curr] is the
  click on position [(x,y)] in the garden. [m] is the current mega state. If
  there is zombie or plant on that spot then the plant is not planted and
  [prev'] is [prev], [m'] is [m]. Otherwise it is planted, [prev'] is [curr]
  and [m'] is the resulting mega state.*)
let plant_flora_helper f (x,y) prev curr m =
  if get_num_in_stock f m <= 0 then (prev, m)
  else
    match plant_a_flora f (x,y) m with
    | (true, m') -> (curr, m')
    | (false, m') -> (prev, m')

(*[click_garden_after_stock f (x,y) prev curr m] deals with the case where the
  current mouse click [curr] is on a point [(x,y)] in the garden and there is a
  flora of type [f] selected in the stock panel waiting to be planted. [prev] is
  the previous mouse click that selects [f] in the stock panel. [m] is the
  current mega state. It returns [(prev',m')], where [m'] is the mega state that
  results from acting [curr] on [m]. If there is sunlight in the tile where
  [(x,y)] sits, then that sunlight is collected and [f] still waits to be
  planted. If there is no sunlight in this tile, then [f] is planted iff no
  plant or zombie occupies the same tile. In any case where [f] is not planted,
  [prev'] is [prev]. If [f] is planted, then [prev'] is [curr].*)
let click_garden_after_stock f (x,y) prev curr m =
  match tile_of_coord (x,y) m with
  | Some (c, r) ->
    if sunlight_of_tile (c, r) m = None then
      plant_flora_helper f (x,y) prev curr m
    else (prev, collect_sunlight (c, r) m)
  | None -> (prev, m)

(*[click_garden (x,y) prev curr m] deals with the case where the current mouse
  click [curr] is on a point [(x,y)] in the garden and there is no flora
  selected in the stock panel waiting to be planted. [prev] is a previous valid
  mouse lick. [m] is the current mega state. It returns [(prev',m')], where
  [prev'] is [prev] if [(x,y)] is not in the garden and [m'] is the mega state
  that results from acting [curr] on [m].*)
let click_garden (x,y) prev curr m =
  match tile_of_coord (x,y) m with
  | Some (c, r) ->
    if sunlight_of_tile (c, r) m = None then
      (curr, m)
    else (curr, collect_sunlight (c, r) m)
  | None -> (prev, m)

(*[make_move prev curr m] is [(prev',m')] where [prev] is the latest mouse click
  on an available flora in stock that has not been planted yet if there exists
  such a mouse click, otherwise [prev] is a previous valid mouse click (may not
  be on the stock). [curr] is the current mouse click that waits for response of
  the program. [m] is the current mega state. [prev'] satisfies the same
  specification as [prev] for the next call to [make_move]. [m'] is the mega
  state that results from [curr].*)
let make_move prev curr m =
  (*print_clicked prev;*)
  match (prev, curr) with
  | (Cstock f1, Cstock f2) ->
    if get_num_in_stock f2 m > 0 then
      (curr, select_flora_in_stock f1 false m |> select_flora_in_stock f2 true)
    else (prev, m)
  | (_, Cstock f2) ->
    if get_num_in_stock f2 m > 0 then
      (curr, select_flora_in_stock f2 true m)
    else (prev, m)
  | (Cstock f, Cgarden (x,y)) ->
    click_garden_after_stock f (round x, round y) prev curr m
  | (_, Cgarden (x,y)) -> click_garden (round x, round y) prev curr m
  | (_, Cstart) -> failwith "Unimplemented"
