open State

(* Sprite record object containing information about each sprite item - plant, camel, projectile *)
type sprite = {
  coords: float*float; (* coordinates of sprite in context *)
  mutable current_frame: int; (* current sprite # *)
  mutable max_frame_count: int; (* total # of images in sprite *)
  mutable count: int; (* count used to slow down animation speed *)
  reference: string; (* path to sprite *)
  frame_size: float*float;
  mutable offset: float*float; (* location of current frame image in sprite*)
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
    offset = (0.,0.);
    count = 0;
  }