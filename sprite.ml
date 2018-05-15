(* Sprite record object containing information about each sprite item - plant, camel, projectile *)
type sprite = {
  mutable coords: float*float; (* coordinates of sprite in context *)
  mutable current_frame: int; (* current sprite # *)
  mutable max_frame_count: int; (* total # of images in sprite *)
  mutable count: int; (* count used to slow down animation speed *)
  reference: string; (* path to sprite *)
  frame_size: float*float;
  mutable offset: float*float; (* location of current frame image in sprite*)
}

let to_sprite objtype coords =
  let max_frame_count = (
    match objtype with
    | "peashooter" -> 24 
    | "ocaml" -> 6
    | "sunflower" -> 53
    | "projectile" -> 1
    | _ -> 1
  ) in 
  let reference = (
  match objtype with
    | "peashooter" -> "sprites/peashooter.png"
    | "ocaml" -> "sprites/zombie_girl.png"
    | "projectile" -> "sprites/peashooter_projectile.png"
    | "sunflower" -> "sprites/sunflower.png"
    | "sunlight" -> "sprites/sun.png"
    | _ -> ""
  ) in
  let size = (
  match objtype with
    | "peashooter" -> (47.,47.)
    | "ocaml" -> (31.,55.)
    | "projectile" -> (12.,12.)
    | "sunflower" -> (50.,50.)
    | "sunlight" -> (31.,31.)
    | _ -> (0.,0.)
  )
  in 
  {
    coords = coords;
    current_frame = 1;
    max_frame_count = max_frame_count;
    reference = reference;
    frame_size = size;
    offset = (0.,0.);
    count = 1;
  }