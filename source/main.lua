import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import("blendate")


local pd = playdate
local gfx = playdate.graphics

import("clear")  
import("tiles")
import("character")
--- TODOs:
--- add dynamic loading                      TODO, URGENT
--- make modding framework                   TODO, URGENT       I need to do this soon since if I do it later it will be hard to implement around everything else (use the loadPDZ function)
--- Rewrite the blendate.lua script          TODO, KINDA URGENT
--- Make characters in Blender               TODO, URGENT

local tileMetadata = Blendate("tiles/TileMetadata.json")

----------------TILES-----------------------

CLEAR.tiles.initTileSystem(tileMetadata, 10, 10, 5, 5)
CLEAR.tiles.addTile("tiles/Corner1", 5, 5, 0)
CLEAR.tiles.addTile("tiles/Wall1", 5, 6, 1)
CLEAR.tiles.addTile("tiles/Wall1", 6, 5, 0)
CLEAR.tiles.addTile("tiles/Floor1", 6, 6, 0)
CLEAR.tiles.addTile("tiles/DeadEnd1", 4, 6, 0)
CLEAR.tiles.addTile("tiles/Floor1", 3, 6, 0)
CLEAR.tiles.addTile("tiles/Floor1", 3, 5, 0)
CLEAR.tiles.addTile("tiles/Wall1", 4, 5, 0)
CLEAR.tiles.addTile("tiles/Floor1", 3, 4, 0)
CLEAR.tiles.addTile("tiles/Floor1", 4, 4, 0)
CLEAR.tiles.addTile("tiles/Floor1", 5, 4, 0)
CLEAR.tiles.addTile("tiles/Floor1", 6, 4, 0)

CLEAR.char.new("template")

function pd.update()
    gfx.clear()

    CLEAR.update() --- all in one update function for the framework, feel free to modify this if you want

end