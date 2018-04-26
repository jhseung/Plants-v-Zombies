open State

type flora_t = unit

type mega = {
  stock : (flora_t * int) list
  st : state;
}

(*[same f1 f2] is true iff f1 and f2 are the same type of flora. *)
let same f1 f2 = failwith "Unimplemented"

let get_num_in_stock f m =
  List.find (fun (f',n') -> same f f') m.stock |> snd

(*[change_stock f n stk] is the updated stock after the number of flora of type
  [f] has been changed by [n] in the stock [stk]. If [n] is positive then flora
  are added and otherwise taken away. *)
let change_stock f n stk =
  List.map (fun (f',n') -> if same f f' then (f',n' + n) else (f',n')) stk

(*maximum price of a single flora.*)
let max_price = 3

(*number of species of flora.*)
let n_species = 2

(*[price f] is the price of a single flora of type [f].*)
let price f = failwith "Unimplemented"

(*[flora_of_int i] is the flora type mapped to integer [i].*)
let flora_of_int i = failwith "Unimplemented"

(*[buy_flora bal stk] is [(bal',stk')] where [bal'] is the remaining balance and
  [stk'] is the replenished stock after flora has been bought with a balance of
  [bal] and the stock before the purchase being [stk]. The sunlights are the
  currency and the purchase is determined entirely by the game instead of the
  player. The program determines which flora to buy in a random manner and keeps
  buying until the balance is not greater than [max_price].*)
let rec buy_flora bal stk =
  if bal <= max_price then (bal, stk)
  else
    let f = Random.int n_species |> flora_of_int in
    let p = price f in
    if p <= bal then buy_flora (bal - p) (change_stock f 1 stk)
    else buy_flora bal stk
