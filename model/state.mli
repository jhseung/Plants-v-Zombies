type state = (tile array) array

type object = |Animated of animated |Static of plant

type info = {zombies: zombie; plants: plant; projectiles: projectile}

(* [init_state col row] is the initial state with col columns and row rows. *)
val init_state : int -> int -> state

(* [score s] is the current score of the state [s]. *)
val score : state -> int

(* [do' c s] returns a new state [s'] that represents the new state after a command [c]
 * has been made on state [s]. Returns [s] if [c] is not a valid command.  *)
val do' : Command.command -> state -> state 

(* Update all the tiles by one move *)
val update: state -> unit

(* Returns the info for the state *)
val get_info: state -> info

(* Returns the coordinates of the object *)
val get_coordinates: object -> int*int

(* Returns the state with a new plant at coordinates (x, y) *)
val make_plant: shooter -> int -> int -> plant

(* Return sthe state with a new zombie at coordinates (_, y) *)
val make_zombie: mummy -> int -> state
