open State
open Mega
open Sprite

module Html = Dom_html
let js = Js.string
let document = Html.document

(* ARBITRARY FOR NOW *)
let screen_width = 650.
let screen_height = 350.

let tile_offset_width = 100
let tile_offset_height = 80

let peashooter_slowdown = 5

type background_object = {
  coords: float*float;
  img_src: string;
}

(* TODO: Change so that color changes depending on whether item is on 
 * cooldown or not. *)
let (background : background_object list) = [
  {
    coords=(100.,0.);
    img_src="sprites/peashooter-card.png";
  };
  {
    coords=(170.,0.);
    img_src="sprites/sunflower-card.png";
  };
  {
    coords=(100.,80.);
    img_src="sprites/tiles.png"
  }
]

let sprite_list = [
  {
    coords=(100.,80.);
    current_frame=1;
    max_frame_count=24;
    reference="sprites/peashooter.png";
    frame_size=(52.,52.);
    offset=(0.,0.);
    count=0;
  };
  {
    coords=(100.,130.);
    current_frame=1;
    max_frame_count=24;
    reference="sprites/peashooter.png";
    frame_size=(52.,52.);
    offset=(0.,0.);
    count=0;
  }
]

(* [peashooter_sprite] updates the sprite field of a peashooter *)
let update_peashooter_sprite (sprite:sprite) =
  let (x,y) = sprite.offset in
  if sprite.max_frame_count > sprite.current_frame then
    if sprite.current_frame mod 5 <> 0 then
    begin
      if sprite.count mod peashooter_slowdown = peashooter_slowdown-1 then
      begin
        sprite.offset <- (x+.52.,y);
        sprite.current_frame <- sprite.current_frame + 1;
        sprite.count <- 0;
      end
      else sprite.count <- sprite.count + 1;
    end
    else 
    begin 
      if sprite.count mod peashooter_slowdown =peashooter_slowdown-1 then
      begin
        sprite.offset <- (0.,y+.53.2);
        sprite.current_frame <- sprite.current_frame + 1;
        sprite.count <- 0;
      end
      else
      sprite.count <- sprite.count + 1;
    end
  else begin
    sprite.current_frame <- 1;
    sprite.count <- 0;
    sprite.offset <- (0.,0.);
  end

(* [update_sunflower_sprite] updates the sprite field of a sunflower *)
let update_sunflower_sprite sprite = 
  let curr = sprite.current_frame in
  let (x,y) = sprite.offset in
  if sprite.max_frame_count >= sprite.current_frame then
    if curr mod 5 <> 0 then
    begin
      sprite.offset <- (x+.47.,y);
    end
    else begin sprite.offset <- (0.,y+.47.);
    sprite.current_frame <- sprite.current_frame + 1;
  end
  else begin
    sprite.current_frame <- 0;
    sprite.offset <- (0.,0.);
  end;;

let update_zombie_sprite sprite =
  let curr = sprite.current_frame in
  let (x,y) = sprite.offset in
  if sprite.max_frame_count >= sprite.current_frame then
    if curr mod 5 <> 0 then
    begin
      sprite.offset <- (x+.61.,y);
    end
    else begin sprite.offset <- (0.,y+.61.);
    sprite.current_frame <- sprite.current_frame + 1;
    end
  else begin
    sprite.current_frame <- 0;
    sprite.offset <- (0.,0.);
  end;;

(* [render_sprite context sprite] renders to context given the sprite information. *)
let render_sprite (context: Html.canvasRenderingContext2D Js.t) sprite =
  let img = Html.createImg document in
  let (clipx,clipy) = sprite.offset in
  let (w,h) = sprite.frame_size in
  let (x,y) = sprite.coords in 
  img##src <- js sprite.reference;
  context##drawImage_full (img, clipx, clipy, w, h, x, y, w, h);;

let update_sprite spr =
  (match spr.reference with
    | "sprites/peashooter.png" -> 
      update_peashooter_sprite spr; spr
    | "sprites/sunflower.png" ->
      update_sunflower_sprite spr; spr
    | "sprites/camel.png" ->
      update_zombie_sprite spr; spr
    | _ -> spr);;

let draw_sprites context spr_list = 
  let updated_sprites = List.map (fun x -> update_sprite x) spr_list in
  List.map (fun x -> render_sprite context x) updated_sprites |> ignore;;

(* TODO: I need an imperative sprite list inside of mega or state to update the models
 * accordingly. I'm really not sure if using tiles is the right way to go about this.
 * Cannot have correct animations w/o strong references to each sprite object.*)
(* [render_tiles context state] renders to screen all the tile information of
 * state object. *)
let draw_tiles (context: Html.canvasRenderingContext2D Js.t) (state:state) =
  for i = 0 to Array.length state.tiles - 1 do
    let tile_row = state.tiles.(i) in
    for j = 0 to Array.length state.tiles - 1 do
      let tile = tile_row.(j) in
      let zombies = tile.zombies in
      let plant = tile.plant in
      let projectiles = tile.projectiles in
      (match plant with
      | Some p -> 
        let plant_sprite = to_sprite "peashooter" 47. (float_of_int tile.x, float_of_int tile.y) in
        render_sprite context plant_sprite;
      | None -> ());
    done
  done;;

(* [draw_with_context] draws to context an image given [img_src] as the path file to 
 * the image and [coord] as the top-left point of the image. *)
let draw_with_context (context: Html.canvasRenderingContext2D Js.t) img_src coord =
  let image = Html.createImg document in 
  image##src <- js img_src;
  context##drawImage (image, (fst coord), (snd coord));;

(* [draw_constants context] draws the base background of the game. *)
let draw_constants (context: Html.canvasRenderingContext2D Js.t) =
  List.map (fun x -> draw_with_context context x.img_src x.coords) background;;

let clear_context (context: Html.canvasRenderingContext2D Js.t) = 
  context##clearRect (0., 0., screen_height, screen_width) |> ignore

let render_page (context: Html.canvasRenderingContext2D Js.t) mega = 
  (* clear_context context;  *)
  context |> draw_constants |> ignore;
  draw_sprites context sprite_list;