open State

(* Sprite record object containing information about each sprite item - plant, camel, projectile *)
type sprite = {
  coords: float*float; (* coordinates of sprite in context *)
  mutable current_frame: int; (* current sprite # *)
  mutable max_frame_count: int; (* total # of images in sprite *)
  reference: string; (* path to sprite *)
  frame_size: float*float;
  mutable offset: float*float; (* location of current frame image in sprite*)
}

(* [to_sprite] takes in an object representing the object type, an int representing
 * the the size of the sprite, and int*int representing the coordinates for the 
 * sprite to be placed in the context, and returns a sprite object. *)
val to_sprite : string -> float -> float*float -> sprite
