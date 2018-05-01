open State
open Mega

module Html = Dom_html
let js = Js.string
let document = Html.document

let state = init_state

let num_rows = 5
let num_cols = 9
let tile_size = 50
let top_left_coord = (0,0)

let assert_fail = fun _ -> assert false

let get_element id =
  Js.Opt.get (Html.document##getElementById (js id)) assert_fail

(* Difficulty of playing level -- number of zombies *)
let difficulty = 10

let mega = ref (init_mega num_rows num_cols tile_size top_left_coord difficulty)

(* Loop game state. *)
let main_loop context =
  let rec game_loop () =
    Gui.render_page context !mega;
    (* mega := update_mega !mega; *)
    Html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> game_loop ())
    ) |> ignore in
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
  main_loop context;;

let _ = start ()