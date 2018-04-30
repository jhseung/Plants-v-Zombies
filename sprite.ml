open State

(* Sprite record object containing information about each sprite item - plant, camel, projectile *)
type sprite = {
  coords: int*int; (* coordinates of sprite in context *)
  mutable current_frame: int; (* current sprite # *)
  mutable max_frame_count: int; (* total # of images in sprite *)
  reference: string; (* path to sprite *)
  frame_size: int*int;
  mutable offset: int*int; (* location of current frame image *)
}

let to_sprite objtype size coords =
  let max_frame_count = (
    match objtype with
    | "peashooter" -> 24 
    | "ocaml" -> 5
    | _ -> 1
  ) in 
  let reference = (
  match objtype with
    | "peashooter" -> "sprites/peashooter.png"
    | "ocaml" -> "sprites/camel.png"
    | _ -> "sprites/projectile.png"
  ) in 
  {
    coords = coords;
    current_frame = 0;
    max_frame_count = max_frame_count;
    reference = reference;
    frame_size = (size,size);
    offset = (0,0);
  }