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

(* Difficulty of playing level -- number of zombies *)
let difficulty = 10

let mega = ref (init_mega num_rows num_cols tile_size top_left_coord difficulty)

(* Loop game state. *)
let main_loop context =
  let rec game_loop () =
    Gui.render_change context !mega;
    Gui.render_constant context !mega;
    mega := update_mega !mega;
    Html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> game_loop ())
    ) |> ignore in
  game_loop ()

(* Initialize game loop. *)
let start _ = 
  let gui = Js.Opt.get (Html.document##getElementById (js "gui")) (fun _ -> assert false) in
  let h1 = Html.createH1 document in
  let canvas = Html.createCanvas document in
  Dom.appendChild h1 (document##createTextNode (js "Plants v Camls"));
  canvas##width <- 350;
  canvas##height <- 650; 
  Dom.appendChild gui canvas;
  let context = canvas##getContext (Html._2d_) in
  main_loop context;
