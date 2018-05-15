open State
open Mega
open Sprite

module Html = Dom_html
let js = Js.string
let document = Html.document

(* ARBITRARY FOR NOW *)
let screen_width = 650.
let screen_height = 350.

let tile_offset_width = 0.
let tile_offset_height = 80.

type background_object = {
  coords: float*float;
  img_src: string;
}

(* TODO: Change so that color changes depending on whether item is on 
 * cooldown or not. *)
let (background : background_object list) = [
  {
    coords=(0.,0.);
    img_src="sprites/peashooter-card.png";
  };
  {
    coords=(80.,0.);
    img_src="sprites/sunflower-card.png";
  };
  {
    coords=(tile_offset_width,tile_offset_height);
    img_src="sprites/tiles.png"
  }
]

(* [peashooter_sprite] updates the sprite field of a peashooter *)
let update_peashooter_sprite (sprite:sprite) =
  let (x,y) = sprite.offset in
  if sprite.max_frame_count > sprite.current_frame then
    if sprite.current_frame mod 5 <> 0 then
    begin
        sprite.offset <- (x+.52.,y);
        sprite.current_frame <- sprite.current_frame + 1;
    end
    else 
    begin 
        sprite.offset <- (0.,y+.53.2);
        sprite.current_frame <- sprite.current_frame + 1;
    end
  else begin
    sprite.current_frame <- 1;
    sprite.offset <- (0.,0.);
  end

(* [update_sunflower_sprite] updates the sprite field of a sunflower *)
let update_sunflower_sprite sprite = 
  let (x,y) = sprite.offset in
  if sprite.max_frame_count > sprite.current_frame then
    if sprite.current_frame mod 5 <> 0 then
    begin
        sprite.offset <- (x+.50.,y);
        sprite.current_frame <- sprite.current_frame + 1;
    end
    else 
    begin 
        sprite.offset <- (0.,y+.49.2);
        sprite.current_frame <- sprite.current_frame + 1;
    end
  else begin
    sprite.current_frame <- 1;
    sprite.offset <- (0.,0.);
  end

let update_zombie_sprite sprite =
  let (x,y) = sprite.offset in
  if sprite.max_frame_count > sprite.current_frame then
    if sprite.count mod 2 = 0 then
    begin
    sprite.offset <- (x+.31.3,y-.0.4);
    sprite.current_frame <- sprite.current_frame + 1;
    sprite.count <- 1;
    end
    else
    begin
    sprite.count <- sprite.count + 1;
    end
  else begin
    sprite.current_frame <- 1;
    sprite.offset <- (0.,0.);
  end;;

(* [render_sprite context sprite] renders to context given the sprite information. *)
let render_sprite (context: Html.canvasRenderingContext2D Js.t) sprite =
  let img = Html.createImg document in
  let (clipx,clipy) = sprite.offset in
  let (w,h) = sprite.frame_size in
  let (x,y) = sprite.coords in (*print_float x; print_endline "actual sprite";*)
  img##src <- js sprite.reference;
  context##drawImage_full (img, clipx, clipy, w, h, x, y, w, h);;

let update_sprite spr =
  (match spr.reference with
    | "sprites/peashooter.png" -> 
      update_peashooter_sprite spr; spr
    | "sprites/sunflower.png" ->
      update_sunflower_sprite spr; spr
    | "sprites/zombie_girl.png" ->
      update_zombie_sprite spr; spr
    | _ -> spr);;

let draw_sprites context spr_list = 
  let updated_sprites = List.map (fun x -> update_sprite x) spr_list in
  List.map (fun x -> render_sprite context x) updated_sprites |> ignore;;

(* [draw_with_context] draws to context an image given [img_src] as the path file to 
 * the image and [coord] as the top-left point of the image. *)
let draw_with_context (context: Html.canvasRenderingContext2D Js.t) img_src coord =
  let image = Html.createImg document in 
  image##src <- js img_src;
  context##drawImage (image, (fst coord), (snd coord));;

(* [draw_constants context] draws the base background of the game. *)
let draw_constants (context: Html.canvasRenderingContext2D Js.t) =
  List.map (fun x -> draw_with_context context x.img_src x.coords) background;;

(* [draw_sunflower_balance] draws the current sunflower balance *)
let draw_sunflower_balance (context: Html.canvasRenderingContext2D Js.t) balance =
  let balance = js ("Sunflower: " ^ string_of_int balance) in
  context##fillStyle <- js "black";
  context##font <- js "16px Helvetica";
  context##fillText (balance, 450., 30.);;

let draw_stock_balance (context: Html.canvasRenderingContext2D Js.t) balance name =
  let balance = js (name ^ ": " ^ string_of_int balance) in
  context##fillStyle <- js "black";
  context##font <- js "12px Helvetica";
  match name with
  | "peashooter" -> context##fillText (balance, 0., 50.);
  | "sunflower" -> context##fillText (balance, 80., 50.);
  | _ -> ();;

let draw_stock_balances (context: Html.canvasRenderingContext2D Js.t) stock =
  let get_bal = function
  | (_,_,bal) -> bal in
  let get_name = function 
  | (name,_,_) -> name in
  List.map (fun x -> draw_stock_balance context (get_bal x) (get_name x)) stock |> ignore;;

let clear_context (context: Html.canvasRenderingContext2D Js.t) = 
  context##clearRect (0., 0., 1000., 1000.) |> ignore

let to_sprites st =
  let objects = get_objects st in
  let helper obj =
    let x,y = get_coordinates obj in
    let crds = (x, y) in
    (match get_type obj with
    | "peashooter" -> to_sprite "peashooter" crds
    | "sunflower" -> to_sprite "sunflower" crds
    | "projectile" -> to_sprite "projectile" crds
    | "ocaml" -> to_sprite "ocaml" crds
    | _ -> to_sprite "projectile" crds)
    in
  List.map helper objects

let get_sprites st = 
  let objects = get_objects st in
  let helper obj = 
    (match obj with
    | Zombie z -> z.z_sprite
    | Plant p -> p.p_sprite
    | Projectile p -> p.sprite
    ) in 
  List.map helper objects

let draw_sunlights context mega = 
  let coords = get_sun_coords mega in
  let sprite_list = List.map (fun x -> to_sprite "sunlight" x) coords in
  List.map (fun x -> render_sprite context x) sprite_list |> ignore;;

let render_page (context: Html.canvasRenderingContext2D Js.t) (mega:mega) = 
  clear_context context; 
  context |> draw_constants |> ignore;
  let spr_list = mega.st |> get_sprites in
  draw_sunflower_balance context mega.sun_bal;
  draw_stock_balances context mega.stock;
  draw_sunlights context mega;
  draw_sprites context spr_list;
