open Object

type state = {top_left: int*int; tiles: (tile array) array;
              mutable sunlight: int; mutable total: int}

type objects = {zombies: zombie list; plants: plant list;
                projectiles: projectile list}

type character = |Z of zombie |P of plant
