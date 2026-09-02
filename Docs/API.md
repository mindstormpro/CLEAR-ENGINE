# The CLEAR-ENGINE Lua API! :b
everything here ~~could~~ will change a lot from commit to commit and I will try to keep this API doc updated so please look here whenever you update your version of CLEAR-ENGINE :)  
I have also tried to make some of the core functions (including this one) easy to patch so 
## `clear.lua` functions and values

### `function CLEAR.update()`  
This function is the main update function that handles the updating and drawing of everything on the screen like the tiles, UI, and characters. 
**I reccomend patching this function to suit your needs!**  

### `string CLEAR.state` Read & Write
Contains the current gamestate, not used by any functions right now but will be used heavily with the implementation of actions, essentially this value holds values like `planning`, `action`, `retaliation`, ect.

### `int CLEAR.rotation` Read & Write
Stores the rotation value used to calculate what frame to render for all tiles and characters. Not set by anything in the CLEAR-ENGINE framework, so you have to wire it up to the crank or some other input method.  

### `float CLEAR.sin & CLEAR.cos` Read Only
Stores the sine and cosine values calculated for that frame by the `CLEAR.tiles.computeTiles()` function. These values are given so they only get calculated once, and are used to figure out any given tile/character/object's position on the screen (see `character.update()` in `template.lua` for an example on usage)

## `tiles.lua` functions and values

### `function CLEAR.tiles.initTileSystem(metadata, w, h)` 
Initializes the tile system and sets up the tile array (`CLEAR.tiles.tileArr`).  
`metadata` is the returned object from doing `Blendate("path/to/your/tile/metadata.json")`, the path used in the demo is `tiles/TileMetadata.json`. It holds all of the metadata for the rendered 3D models of each tile in your game.  
`w` is the width of the world, and accordingly `h` is the height of the world in units (1 unit is one tile).

### `Int CLEAR.tiles.tileMapW & CLEAR.tiles.tileMapH` Read Only
Stores the width and height of the tilemap in units (1 tile = 1 unit) initialized by `CLEAR.tiles.initTileSystem()`.

### `Int CLEAR.tiles.centerX & CLEAR.tiles.centerY` Read Only
Stores the center tile's x and y values on the tilemap, set by `CLEAR.tiles.initTileSystem()`.

### `function CLEAR.tiles.addTile(path, tx, ty, rot, doReplace`
Adds a tile, where `tx` and `ty` are the `x` and `y` coordinates of the tiles in the world in units, `rot` is the 90 degree offset where `1 rot = 90*` so you can set `rot` to 2 which will have the tile rotated by 180 degrees, and `doReplace` is a boolean that is by default false, and when it is true and there is a tile present where you are trying to place another tile it will overwrite the tile, otherwise it will throw an error in the logs and return without placing a tile.

### `function CLEAR.tiles.hideTile(x, y, value)`
sets the tile at `x`, `y`'s hidden value to the boolean `value`. For example if `value` is `true` then the tile would not be drawn for all future drawing calls untill set to `false`.

### `function CLEAR.tiles.isHidden(x, y)`
returns a boolean, `true` if the tile at `x`, `y` is hidden, otherwise `false`.

