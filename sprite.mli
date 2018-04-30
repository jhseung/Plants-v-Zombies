open State
open Mega


(* Sprite record object containing information about each sprite item - plant, camel, projectile *)
type sprite = {
  column: int;
  id: int;
  ob_type: ob;
  mutable sprite_count: int;
  mutable frame_count: int;
  mutable max_frame_count: int;
  reference: string;
}