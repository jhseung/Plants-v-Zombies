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

(* [state_to_sprite tile] takes in type tile and returns a sprite object. *)
let state_to_sprite (tile: tile) = failwith "un"

(* [peashooter_sprite] updates the sprite field of a peashooter *)
let update_peashooter_sprite sprite =
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

(* [render_sprite context sprite] renders to context given the sprite information. *)
let render_sprite context sprite =
  let img = Html.createImg document in
  let (clipx,clipy) = sprite.offset in
  let (w,h) = sprite.frame_size in
  let (x,y) = sprite.coords in failwith "d"
  (* img##src <- js sprite.reference;
  context##drawImage_full (img, clipx, clipy, w, h, x, y, w, h) *)

(* [render_tiles context state] renders to screen all the tile information of
 * state object. *)
let render_tiles (context: Html.canvasRenderingContext2D Js.t) (state:state) =
  for i = 0 to Array.length state.tiles - 1 do
    let tile_row = state.tiles.(i) in
    for j = 0 to Array.length state.tiles - 1 do
      let tile = tile_row.(j) in
      let zombie = tile.zombies in
      let plant = tile.plant in
      let projectiles = tile.projectiles in
      failwith "dd"
    done
  done

let clear_context (context: Html.canvasRenderingContext2D Js.t) = failwith "weird"
  (* context##clearRect (0., 0., screen_height, screen_width) |> ignore *)

let render_constant (context:Html.canvasRenderingContext2D Js.t) = failwith "unimpl"

let render_change (context: Html.canvasRenderingContext2D Js.t) mega =
  clear_context context;