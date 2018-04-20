(*start the window, initialize the game: column, row, plants available in stock*)

(*respond to a click on a plant in the stock: do nothing if the plant appears
  grey (not available); otherwise make the plant appears selected. *)

(*respond to an elapse of time:
  put sunlight in the garden according to the number of sunflowers present in
  the garden;
  pay collected sunlight for more plants and add these plants to stock;
  decide whether to let another zombie(s) enter the garden and from which
  lane(s) they enter;
  update the positions of each zombie according to its velocity and whether it
  collides with a plant;
  let each zombie attack the plant with which it collides.
  decide whether each plant is killed;
  let each shooter shoots a number of projectiles and update the life remaining
  for each zombie;
  decide whether each zombie present is killed;
  decide whether a zombie reaches the house;
  decide whether the player has won.
*)

(*respond to a click on a sunlight: (assume GUI distinguishes a click on
  sunlight from a click on a tile) increase collected sunlight and tell GUI
  to remove the sunlight that is clicked.*)

(*respond to a click on a tile: do nothing if previous click is invalid; plant
  the selected plant on the tile if previous click is on an available plant in
  the stock; *)
