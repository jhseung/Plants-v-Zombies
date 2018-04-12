open Command

let play_game = failwith "Unimplemented"

let enter_store = failwith "Unimplemented"

let switch_mode c = 
match c with 
|Game -> play_game
|Store -> enter_store
