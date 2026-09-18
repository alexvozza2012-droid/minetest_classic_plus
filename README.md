# Minetest Classic Plus

Minetest Classic Plus is a classic-style sandbox game based on [Minetest Classic](https://github.com/sfan5/minetest_classic).

It keeps the simple, old-school sandbox gameplay of Minetest Classic while adding new world generation, building features, vegetation and exploration elements.

The goal is to create a calm, simple and exploration-focused sandbox experience without turning the game into a collection of modern features.

Classic Plus currently uses the classic `v6` map generator as its foundation.

Additional Lua-based generation systems are used to add features such as:

* Custom trees
* Snowy Forests
* Millenary Villages
* Tall Grass

This keeps the underlying world generation simple while allowing Classic Plus to expand it.

## Design Philosophy

Classic Plus focuses on:

* Exploration
* Building
* Creativity
* Simple mechanics
* Discovering unusual places
* A quiet old-school atmosphere

The intention is to expand the classic sandbox experience without overwhelming it with large numbers of unrelated modern systems.

## Installation

### Luanti

Classic Plus can be installed as a game in the Luanti `games` directory.

For development, clone the repository:

```bash
git clone https://github.com/alexvozza2012-droid/minetest_classic_plus.git
```

Then place the game in your Luanti games directory.

Classic Plus requires a Luanti version compatible with the version specified in `game.conf`.

## Development

The project is written primarily in Lua and is designed as a game for the Luanti engine.

The repository contains the game's mods, world generation and configuration.

The engine itself is not included in this repository.

## Based on Minetest Classic

Minetest Classic Plus is a fork of [Minetest Classic](https://github.com/sfan5/minetest_classic) by sfan5 and the Minetest Classic contributors.

Classic Plus retains original components and media from Minetest Classic. Their original license and attribution information are preserved in the repository.

See:

* `LICENSE.md`
* `mods/cl_default/LICENSE.txt`
* `mods/creative/LICENSE.txt`
* `mods/sfinv/LICENSE.txt`

Individual components may have different licenses. Refer to their respective license files for the applicable terms.

## Credits

### Minetest Classic

* sfan5
* celeron55
* Minetest Classic contributors

Classic Plus also contains original work created for this project, including its custom world-generation systems, doors, slabs, Millenary Villages, Snowy Forest and Tall Grass.

## License

Minetest Classic Plus contains components originating from Minetest Classic with their respective original licenses and attribution requirements.

Do not assume that a single license applies to every file in this repository.

Refer to the individual license files for the exact terms applying to each component and media file.
