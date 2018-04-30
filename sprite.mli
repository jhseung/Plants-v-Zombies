open State

(* Sprite record object containing information about each sprite item - plant, camel, projectile *)
type sprite = {
  id: int;
  coords: int*int;
  mutable current_frame: int;
  mutable max_frame_count: int;
  reference: string;
  frame_size: int*int;
  mutable offset: int*int;
}

(* [to_sprite] takes in an object representing the object type, an int representing
 * the the size of the sprite, and an int*int representing the coordinates for the 
 * sprite to be placed in the context, and returns a sprite object. *)
val to_sprite : ob -> int -> int*int -> sprite