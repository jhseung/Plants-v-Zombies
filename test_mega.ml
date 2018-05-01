open OUnit2
open Mega

(*[get_selected f m] is true iff the flora of type [f] is selected in the mega
  state [m].*)
let get_selected f m =
  let (_, s'', _) = List.find (fun (f', _, _) -> f = f') m.stock in
  s''

let tests =
  let initial_m = init_mega 3 2 5 (0,0) 1 in
  let initial_m_copy = initial_m in
  let sunflower_planted_m = plant_a_flora "sunflower" (2,3) initial_m_copy
                            |> snd in
  (*let updated_m_1 = update_mega sunflower_planted_m in *)
[
  "peashooter in initial stock" >::
  (fun _ -> assert_equal 0 (get_num_in_stock "peashooter" initial_m));

  "sunflower in initial stock" >::
  (fun _ -> assert_equal 1 (get_num_in_stock "sunflower" initial_m));

  "peashooter in initial stock selected" >::
  (fun _ -> assert_equal false (get_selected "peashooter" initial_m));

  "select peashooter" >::
  (fun _ -> assert_equal true (select_flora_in_stock "peashooter" true initial_m
                               |> get_selected "peashooter"));

  "deselect peashooter" >::
  (fun _ -> assert_equal false
      (select_flora_in_stock "peashooter" true initial_m
       |> select_flora_in_stock "peashooter" false
       |> get_selected "peashooter"));

  "sunflower in stock after planted from initial stock" >::
  (fun _ -> assert_equal 0 (get_num_in_stock "sunflower" sunflower_planted_m));

  "sunflower deselected after planted from initial stock" >::
  (fun _ -> assert_equal false (get_selected "sunflower" sunflower_planted_m));
  (*
  "number of tiles without sun after updating the field with one sunflower by"^
  "one step" >::
  (fun _ -> assert_equal 5 updated_m_1.num_tiles_wout_sun);*)
]
