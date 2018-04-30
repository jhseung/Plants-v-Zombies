open State

(* Sprite record object containing information about each sprite item - plant, camel, projectile *)
type sprite = {
  id: int;
  coords: int*int; (* coordinates of sprite in context *)
  mutable current_frame: int; (* current sprite # *)
  mutable max_frame_count: int; (* total # of images in sprite *)
  reference: string; (* path to sprite *)
  frame_size: int*int;
  mutable offset: int*int; (* location of current frame image *)
}

let to_sprite ob size coords =
  let max_frame_count = (
    match ob with
    | Plant _ -> 24 
    | Zombie _ -> 5
    | Projectile _ -> 1
  ) in 
  let reference = (
  match ob with
    | Plant _ -> "sprites/peashooter.png"
    | Zombie _ -> "sprites/camel.png"
    | Projectile _ -> "sprites/projectile.png"
  ) in 
  {
    id = 0;
    coords = coords;
    current_frame = 0;
    max_frame_count = max_frame_count;
    reference = reference;
    frame_size = (size,size);
    offset = (0,0);
  }