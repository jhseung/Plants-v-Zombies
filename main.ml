open State
open Mega
open Control

module Html = Dom_html
let js = Js.string
let document = Html.document

let state = init_state

let num_rows = 5
let num_cols = 9
let tile_size = 50
let top_left_coord =(0,0)

let assert_fail = fun _ -> assert false

let get_element id =
  Js.Opt.get (Html.document##getElementById (js id)) assert_fail

(* Difficulty of playing level -- number of zombies *)
let difficulty = 10

(* Initialize mega state with ref *)
let mega = ref (init_mega num_rows num_cols tile_size top_left_coord difficulty)

let prev_click = ref Cstart

let in_box (coords: (float*float)) card =
  let x,y = coords in
  let x_init, y_init, height, width = card in 
  if x > x_init && x < x_init +. width && y > y_init && y < y_init +. height then
     true
  else false

(**)
let detect_mouse_click coords =
  let sunflower = (100., 0., 64., 36.) in
  let peashooter = (170., 0., 64., 36.) in
  if in_box coords sunflower then "sunflower"
  else if in_box coords peashooter then "peashooter"
    else "NONE"

(* User click listener *)
let mouseclick (event: Html.mouseEvent Js.t) =
  let coords = (float_of_int event##clientX, float_of_int event##clientY) in
  let click = (  
  match detect_mouse_click coords with
  | "sunflower" -> Cstock "sunflower"
  | "peashooter" -> Cstock "peashooter"
  | _ -> Cstart
  ) in
  let (curr, m) = make_move !prev_click click !mega in
  mega := m;
  prev_click := click; 
  Js._true

let slow_factor = 4

(* Loop game state. *)
let main_loop context =
  let count = ref 1 in
  let rec game_loop () =
    if !count mod slow_factor = 0 then
    begin
    Gui.render_page context !mega;
    mega := update_mega !mega;
    count := 1;
    Html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> game_loop ())
      ) |> ignore; 
    end
    else
    begin
    count := !count + 1;
    Html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> game_loop ())
      ) |> ignore;
    end in
  game_loop ()

(* Initialize game loop. *)
let start () = 
  let gui = get_element "gui" in
  let h1 = Html.createH1 document in
  let canvas = Html.createCanvas document in
  Dom.appendChild h1 (document##createTextNode (js "Plants v Camls"));
  canvas##width <- 650;
  canvas##height <- 350; 
  Dom.appendChild gui canvas;
  let context = canvas##getContext (Html._2d_) in
  let _ = Html.addEventListener 
    document Html.Event.mousedown (Html.handler mouseclick)
    Js._true in
  main_loop context;;

let _ = start ()