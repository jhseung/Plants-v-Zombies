(*type shooter associates the name of the shooter with damage per shot *)
type shooter = |Peashooter of int |Cactus of int

type plant = {plant: shooter; mutable tile: tile; mutable HP: int}

(* plant a shooter on tile *)
val: plant: shooter -> tile -> plant
