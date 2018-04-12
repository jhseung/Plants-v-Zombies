open State

(* [cards] is the cards to move; [src] is the pile (source) where the cards are;
   [dst] is the pile (destination) where the cards are going.*)
type move = {cards : card list; src : card list; dst : card list}

(* [Look] is a function that prints the current state of the game. Does not change state.
 * [Move] is a function that lets the player move a card to a new position.
 * [Move] returns the same state if the given command is not valid.
 * [Flip] displays the next card on the stack, and hides the current card on the stack. 
 * Returns new state 
 * [Restart] restarts the game. Returns a new init_state.
 * [Quit] exits the program. 
 * [Moves] returns the current number of moves.
 * [Undo] returns a new state that is the previous state of current state.
 * [Hint] displays a valid possible move of the current state. *)
type command = Look | Move of move | Flip | Restart | Quit | Moves of int
             | Undo | Hint


type mode = Game | Store
