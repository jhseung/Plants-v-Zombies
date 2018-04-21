type info = {speed: int; hp: int}

type mummy = |Normal of info |Conehead of info |Buckethead of info

type shooter = |Peashooter of info |Cactus of info

type tile = {x: int; y: int; size: int; mutable zombies: zombie list;
mutable plant: plant option; left: tile; right: tile;
mutable projectiles: projectile list}

and projectile = {shoot: shooter; mutable tile: tile; mutable p_step: int;
mutable attacking: bool}

and zombie = {mummy: mummy; mutable z_pos: tile; mutable z_hp: int;
mutable z_step: int; mutable attacked: bool; mutable z_attacking: bool}

and plant = {shooter: shooter; mutable p_pos: tile; mutable p_hp: int;
              mutable p_attacked: bool}

type flora = |Shooter of shooter |Sunflower

type item = |Zombie of zombie |Plant of plant
              |Projectile of projectile

type moving = |Projectile of projectile | Zombie of zombie
