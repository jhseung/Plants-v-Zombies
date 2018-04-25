open State

type flora_t = f_species

(*[st] is the state of the garden (zombies, plants and etc., specified by
  state.mli).
  [stock] = [p1,n1; p2,n2; ...] meaning in the stock there are n1 flora of
             type p1, n2 flora of type p2 ...
*)
type mega = {
  st : state;
  stock : (flora_t * int) list
}

(*[same f1 f2] is true iff f1 and f2 are the same type of flora. *)
val same : flora_t -> flora_t -> bool

(*[get_num_in_stock f m] is the number of the flora of type [f] in the stock in
  the mega state [m].*)
val get_num_in_stock : flora_t -> mega -> int

(*[change_stock f n m] is the mega state after the number of flora of type [f]
  has been changed by [n] in the stock in mega state [m]. If [n] is positive
  then flora are added and otherwise taken away. *)
val change_stock : flora_t -> int -> mega -> mega
