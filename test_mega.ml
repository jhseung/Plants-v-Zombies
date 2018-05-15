open OUnit2
open Mega

(*[get_selected f m] is true iff the flora of type [f] is selected in the mega
  state [m].*)
let get_selected f m =
  let (_, s'', _) = List.find (fun (f', _, _) -> f = f') m.stock in
  s''

(*[repeat f n x] is [f (f (...(f x)))] where [f] acts on [x] for [n] times.*)
let rec repeat f n x =
  match n with
  | 0 -> x
  | n -> repeat f (n-1) (f x)

let tests1 =
  let m = init_mega 3 2 5 (0,0) 1
          |> plant_a_flora "sunflower" (2,3) |> snd
  in
[
  "peashooter in stock" >::
  (fun _ -> assert_equal 1 (get_num_in_stock "peashooter" m));

  "peashooter in stock selected" >::
  (fun _ -> assert_equal false (get_selected "peashooter" m));

  "select peashooter" >::
  (fun _ -> assert_equal true (select_flora_in_stock "peashooter" true m
                               |> get_selected "peashooter"));

  "deselect peashooter" >::
  (fun _ -> assert_equal false
      (select_flora_in_stock "peashooter" true m
       |> select_flora_in_stock "peashooter" false
       |> get_selected "peashooter"));

  "sunflower in stock after planted from initial stock" >::
  (fun _ -> assert_equal 0 (get_num_in_stock "sunflower" m));

  "sunflower deselected after planted from initial stock" >::
  (fun _ -> assert_equal false (get_selected "sunflower" m));
]

let tests2 =
  let m = init_mega 5 1 10 (0,0) 1
          |> plant_a_flora "sunflower" (2,3) |> snd
          |> repeat update_mega 41
  in
  let tile_lst = [0,0; 1,0; 2,0; 3,0; 4,0] in
  [
    "sunlight_of_tile 41 steps since sunflower planted" >::
    (fun _ -> assert_equal [Some 0]
        (List.fold_left
           (fun acc (c,r) ->
              let age = sunlight_of_tile (c,r) m in
              if age = None then acc else age::acc
           )
           [] tile_lst));

    "sunlight dissipated" >::
    (fun _ -> assert_equal [Some 11]
        (let md = repeat update_mega 51 m in
         List.fold_left
           (fun acc (c,r) ->
              let age = sunlight_of_tile (c,r) md in
              if age = None then acc else age::acc
           )
           [] tile_lst));

    "stock after collecting sunlight" >::
    (fun _ -> assert_equal true
        (let collect = fun m ->
            List.fold_left
             (fun m (c,r) ->
                let age = sunlight_of_tile (c,r) m in
                if age != None then collect_sunlight (c,r) m else m
             )
             m tile_lst |> update_mega
         in
         let m' = repeat collect 500 m in
         get_num_in_stock "sunflower" m' > 0
         || get_num_in_stock "peashooter" m' > 1));

  ]

let tests = tests1 @ tests2
