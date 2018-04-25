open State

type flora_t = f_species

type mega = {
  stock : (flora_t * int) list
  st : state;
}

let same f1 f2 = failwith "Unimplemented"

let get_num_in_stock f m =
  List.find (fun (f',n') -> same f f') m.stock |> snd

let change_stock f n m =
  List.map (fun (f',n') -> if same f f' then (f',n' + n) else (f',n')) m.stock
