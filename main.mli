open State
open Command


(* [start s] Runs the game with the given state [s]. *)
val start : state -> unit()

(* [load_game] returns [s] of Some state if there is a unfinished game 
 * of solitaire. Otherwise, returns None. *)
val load_game : unit() -> option state


(* [run_game] returns the proper state of the game to be run.
 * May or may not return a previously unfinished state depending on
 * such existence and user input. *)
val run_game : unit() -> state