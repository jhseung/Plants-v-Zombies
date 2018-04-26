open State

type flora_t = unit (*TODO: fill in the type here*)

(*[st] is the state of the garden (zombies, plants and etc., specified by
  state.mli).
  [stock] = [p1,n1; p2,n2; ...] meaning in the stock there are n1 flora of
             type p1, n2 flora of type p2 ...
*)
type mega

(*[get_num_in_stock f m] is the number of the flora of type [f] in the stock in
  the mega state [m].*)
val get_num_in_stock : flora_t -> mega -> int
