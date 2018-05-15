# Plants vs Zombies

Cornell University's CS 3110 Spring 2018 Final Project.

Contributors:
- Ji Hwan Seung @jhseung
- Jaclyn Huang
- Chengyan Zhan

## Description
This is an implementation of the famous mobile game "Plants vs Zombies". The prime purpose of the game is to defeat the incoming wave of zombies by planting different types of plants. Carefully managing sunflower resources is integral to success in this game. While the original game lets the user decide which type of plant to plant next, this version of the game automatically and randomly generates a stock of a type of plant upon collecting enough sunlight resources. A stock of available plants is maintained.

Key features:
- Web-based GUI that enables smooth user-interaction
- Collision detection and intricate model structures

## Installation

This projects uses js_of_ocaml to compile the code.
After downloading this project, navigate to the downloaded folder using the command line.

### Install the necessary dependencies
`opam install js_of_ocaml js_of_ocaml-ocamlbuild js_of_ocaml-camlp4 js_of_ocaml-lwt`

### Compile
`make`

### Play
`make` creates a javascript file within the build folder.

Open `index.html` to play the game!


### Notes
All user interaction is handled through mouse clicks. Clicking on a plant card and then subsequently clicking on a tile in a garden will plant a plant, assuming that there is remaining stock of that plant type.

Defeat the zombies before they eat your brains!

### Other commands
`make clean` Cleans the `_build` directory
`make test` Runs the unit tests

## Project structure

**control**: Responsible for handling user interaction

**gui**: Displays everything onto the screen, animating where necessary

**sprite**: Contains basic logic for using sprite sheets

**mega**: Updating of the super game state

**main**: Runs the main game loop –– currently runs at 15fps

**object**: Contains the base data models for objects in the game

**state**: Handles all logic for object interaction


## References
All credits for the game idea and plant sprites go to [PopCap](https://www.ea.com/studios/popcap).
All credits for the zombie sprite sheets go to [CraftPix](https://craftpix.net/freebies/2d-game-zombie-character-free-sprite-pack-1/).

Past CS 3110 projects [Legend of Zolda](https://github.com/mindylou/legend-of-zolda) and [MariOCaml](https://github.com/mahsu/MariOCaml) were referenced for the animation code.
