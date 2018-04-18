type state = (tile array) array

(* [rep_ok s] determines whether the current state [s] of the program is
 * valid
 AI: TODO
 RI: TODO *)
val rep_ok : state -> state

(* [init_state col row] is the initial state with col columns and row rows. *)
val init_state : int -> int -> state

(* [score s] is the current score of the state [s]. *)
val score : state -> int

(* [do' c s] returns a new state [s'] that represents the new state after a command [c]
 * has been made on state [s]. Returns [s] if [c] is not a valid command.  *)
val do' : Command.command -> state -> state 

(* Update all the tiles by one move *)
val update: state -> unit

