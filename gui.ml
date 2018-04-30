open State
open Object
open Mega
open Sprite

module Html = Dom_html
let js = Js.string
let document = Html.document

(* ARBITRARY FOR NOW *)
let screen_width = 800.
let screen_height = 500.

type background_object = {
  coords: int*int;
  img_src: string;
}

(* TODO: Change so that color changes depending on whether item is on 
 * cooldown or not. *)
let (background : background_object list) = [
  {
    coords=(100,0);
    img_src="sprites/peashooter-card.png";
  };
  {
    coords=(170,0);
    img_src="sprites/sunflower-card.png";
  };
  {
    coords=(100,80);
    img_src="sprites/tiles.png"
  }
]

(* [state_to_sprite tile] takes in type tile and returns a sprite object. *)
let state_to_sprite (tile: tile) = failwith "un"

(* [peashooter_sprite] updates the sprite field of a peashooter *)
let update_peashooter_sprite (sprite:sprite) =
  let curr = sprite.current_frame in
  let (x,y) = sprite.offset in
  if sprite.max_frame_count >= sprite.current_frame then
    if curr mod 5 <> 0 then
    begin
      sprite.offset <- (x+52,y);
    end
    else begin sprite.offset <- (0,y+52);
    sprite.current_frame <- sprite.current_frame + 1;
  end
  else begin
    sprite.current_frame <- 0;
    sprite.offset <- (0,0);
  end

(* [update_sunflower_sprite] updates the sprite field of a sunflower *)
let update_sunflower_sprite sprite = 
  let curr = sprite.current_frame in
  let (x,y) = sprite.offset in
  if sprite.max_frame_count >= sprite.current_frame then
    if curr mod 5 <> 0 then
    begin
      sprite.offset <- (x+47,y);
    end
    else begin sprite.offset <- (0,y+47);
    sprite.current_frame <- sprite.current_frame + 1;
  end
  else begin
    sprite.current_frame <- 0;
    sprite.offset <- (0,0);
  end

let update_zombie_sprite sprite =
  let curr = sprite.current_frame in
  let (x,y) = sprite.offset in
  if sprite.max_frame_count >= sprite.current_frame then
    if curr mod 5 <> 0 then
    begin
      sprite.offset <- (x+61,y);
    end
    else begin sprite.offset <- (0,y+61);
    sprite.current_frame <- sprite.current_frame + 1;
  end
  else begin
    sprite.current_frame <- 0;
    sprite.offset <- (0,0);
  end

(* [render_sprite context sprite] renders to context given the sprite information. *)
let render_sprite context sprite =
  let img = Html.createImg document in
  let (clipx,clipy) = sprite.offset in
  let (w,h) = sprite.frame_size in
  let (x,y) = sprite.coords in failwith "UGH"
  (* img##src <- js sprite.reference;
  context##drawImage_full (img, clipx, clipy, w, h, x, y, w, h) *)

let draw_sprites context spr_list = failwith "unimP"
  (* let update_sprite spr = 
    match spr.reference with
    | "sprites/peashooter.png" -> 
      update_peashooter_sprite spr; spr
    | "sprites/sunflower.png" ->
      update_sunflower_sprite spr; spr
    | "sprites/camel.png" ->
      update_zombie_sprite spr; spr
    | _ -> spr
  List.map (fun x -> update_sprite x) spr_list *)

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
        let plant_sprite = to_sprite "peashooter" 47 (tile.x, tile.y) in
        render_sprite context plant_sprite |> ignore
      | None -> ());
    done
  done

(* [draw_with_context] draws to context an image given [img_src] as the path file to 
 * the image and [coord] as the top-left point of the image. *)
let draw_with_context context img_src coord =
  let image = Html.createImg document in failwith "WTF"
  (* image##src <- img_src;
  context##drawImage (image, (fst coord), (snd coord)); *)

(* [draw_constants context] draws the base background of the game. *)
let draw_constants context =
  List.map (fun x -> draw_with_context context x.img_src x.coords) background |> ignore

let clear_context (context: Html.canvasRenderingContext2D Js.t) =  failwith "WTF"
  (* context##clearRect (0., 0., screen_height, screen_width) |> ignore *)

let render_constant (context:Html.canvasRenderingContext2D Js.t) mega = 
  context |> draw_constants |> ignore

let render_change (context: Html.canvasRenderingContext2D Js.t) mega =
  clear_context context;
  render_constant context mega;
