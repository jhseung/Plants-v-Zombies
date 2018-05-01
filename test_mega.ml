open OUnit2
open Mega

(*[get_selected f m] is true iff the flora of type [f] is selected in the mega
  state [m].*)
let get_selected f m =
  let (_, s'', _) = List.find (fun (f', _, _) -> f = f') m.stock in
  s''

let tests =
  let initial_m = init_mega 3 2 5 (0,0) 1 in
[
  "peashooter in initial stock" >::
  (fun _ -> assert_equal 0 (get_num_in_stock "peashooter" initial_m));
  "sunflower in initial stock" >::
  (fun _ -> assert_equal 1 (get_num_in_stock "sunflower" initial_m));
  "peashooter in initial stock selected" >::
  (fun _ -> assert_equal false (get_selected "peashooter" initial_m));
]
