type rank = Ace | Two | Three | Four | Five | Six | Seven | Eight |Nine |Ten
          |Jack |Queen |King
type suit = Club | Diamond | Heart | Spade
type color = R | B

(*Unless is_top or is_flipped, the card is hidden. *)
type card = {rank: rank; suit: suit; color: color; is_top: bool; is_flipped: bool}

type error = | Command_Error
             | Type_Error

type msg = | Error of error | State | Score of int | Start | Quit

(*State of the game, contains the information about the piles on 
the board and the total number of moves.*)
type state = {tableau: (card list) list; foundation: (card list) list;
              waste: card list; score: int; has_won: bool; msg: msg}

(* [rep_ok s] determines whether the current state [s] of the program is
 * valid
 AI: TODO
 RI: TODO *)
val rep_ok : state -> state

(* [init_state i] is the initial state when the game starts for the first time. 
 * Initializes the game with i characters in the first column, i + 1 in the second etc.
 * This function is used to define a starting position.*)
val init_state : state

(* [waste_pile s] returns a list of cards that represents the waste pile of [s]. *)
val waste_pile : state -> card list 

(* [tableau n s] is the [n]-th tableau pile in the state [s].
 *requires: n is in 1,2,...,6 inclusive. *)
val tableau : int -> state -> card list

(* [foundation n s] is the [n]-th foundation pile in the state [s].
 * requires: n is in 1,2,3,4 inclusive. *)
val foundation : int -> state -> card list

(* [score s] is the current score of the state [s]. *)
val score : state -> int

(* [num_of_moves s] is the total number of moves made during the current game. *)
val num_of_moves : state -> int

(* [do' c s] returns a new state [s'] that represents the new state after a command [c]
 * has been made on state [s]. Returns [s] if [c] is not a valid command.  *)
val do' : Command.command -> state -> state 

(* [msg s] returns the message list of the current state.
   requires: [s] is the current state. *)
val msg : state -> msg list

