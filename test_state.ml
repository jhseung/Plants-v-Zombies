open OUnit2
open State

let tests1 =
  let st = init_state 2 2 5 (0,0) 1 in
  [
  "get sunlight in initial state" >::
  (fun _ -> assert_equal 0 (get_sunlight st));

  "make plant on empty tile" >::
  (fun _ -> assert_equal true (make_plant "sunflower" (9,2) st));

  "make plant on a tile with plant" >::
  (fun _ -> assert_equal false (make_plant "sunflower" (9,2) st |> ignore;
                                make_plant "peashooter" (8,3) st));

  "make plant on a tile with zombie" >::
  (fun _ -> assert_equal false (make_zombie "ocaml" (4,2) st;
                                make_plant "peashooter" (3,3) st));

  "has_won false" >:: (fun _ -> assert_equal false (has_won st));

  "has_lost false" >:: (fun _ -> assert_equal false (has_lost st));

  "has_lost true" >::
  (fun _ -> assert_equal true
      (make_zombie "ocaml" (0,0) st; update st; has_lost st));
]

let tests2 =
  let st2 = init_state 2 3 5 (0,0) 1 in
  [
    "zombie gets killed" >::
    (fun _ -> assert_equal true
        (make_plant "peashooter" (2,0) st2 |> ignore;
         make_plant "peashooter" (7,0) st2 |> ignore;
         update st2; update st2; update st2; update st2;
         make_zombie "ocaml" (14,0) st2;
         let rec try_kill s acc =
           update s;
           if (get_objects s |> List.map get_type) = ["peashooter"] then
             true
           else if acc > 100 then false
           else try_kill s (acc+1)
         in try_kill st2 0)
    );
  ]

let tests3 =
  let st3 = init_state 1 1 10 (0,0) 1 in
  [
    "sunflower gets eaten" >::
    (fun _ -> assert_equal true
        (make_plant "sunflower" (4,4) st3 |> ignore;
         make_zombie "ocaml" (6,4) st3;
         let rec try_eat s acc =
           update s;
           (*print_state s;*)
           if (get_objects s |> List.map get_type) = ["ocaml"] then
             true
           else if acc > 6 then false
           else try_eat s (acc+1)
         in try_eat st3 0)
    );
  ]

let tests = tests1 @ tests2 @ tests3
