type rank = int
type suit = Club | Diamond | Heart | Spade
type color = R | B

(*Unless is_top or is_flipped, the card is hidden. *)
type card =  {rank: rank; suit: suit; color: color; is_top: bool;
              is_flipped: bool}

type pile = Empty | Cards of card list

(*State of the game, i.e. the visible and invisible cards in each pile,
  the number of moves, etc. *)
type state

val rep_ok : state -> state

(*Initial state when the game starts for the first time. *)
val init_state : state

val waste_pile : state -> pile

(*[tableau n s] is the [n]-th tableau pile in the state [s].
 *requires: n is in 1,2,...,6 inclusive. *)
val tableau : int -> state -> pile

(*[foundation n s] is the [n]-th foundation pile in the state [s].
 *requires: n is in 1,2,3,4 inclusive. *)
val foundation : int -> state -> pile

val score : state -> int

val number_of_moves : state -> int

val do' : Command.command -> state -> state 
