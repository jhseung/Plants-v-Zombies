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

  "get object types in a state with a sunflower and a zombie" >::
  (fun _ -> assert_equal ["ocaml"; "sunflower"]
      (make_zombie "ocaml" (4,2) st;
       let oblst = get_objects st in
       List.map (get_type) oblst |> List.sort (String.compare)));

  "get coordinates in a state with a sunflower and a zombie" >::
  (fun _ -> assert_equal [(7,2);(4,2)]
      (let oblst = get_objects st in
       List.map (get_coordinates) oblst));

  "has_won false" >:: (fun _ -> assert_equal false (has_won st));

  "has_lost false" >:: (fun _ -> assert_equal false (has_lost st));

  "get coordinates after update" >::
  (fun _ -> assert_equal true
      (update st;
       let oblst = get_objects st in
       match List.map (get_coordinates) oblst with
       | [(7,2);(x,2)] -> if x < 4 then true else false
       | _ -> false
      ));

  "get sunlight in state with a sunflower" >::
  (fun _ -> assert_equal true (update st; (get_sunlight st) > 0));

  "has_lost true" >::
  (fun _ -> assert_equal true
      (make_zombie "ocaml" (0,0) st; update st; has_lost st));
]

let tests2 =
  let st2 = init_state 2 2 100 (0,0) 1 in
  [
    "zombie gets killed" >::
    (fun _ -> assert_equal true
        (make_plant "peashooter" (20,40) st2 |> ignore;
         make_zombie "ocaml" (199,50) st2;
         let rec try_kill s acc =
           update s;
           if (get_objects s |> List.map get_type) = ["peashooter"] then
             true
           else if acc > 200 then false
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
