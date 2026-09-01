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
--- add dynamic loading                      TODO, URGENT, TOO LAZY
--- make modding framework                   TODO, URGENT, AGAIN, I'M TOO LAZY       I need to do this soon since if I do it later it will be hard to implement around everything else (use the loadPDZ function)
--- Rewrite the blendate.lua script          basically not needed anymore, so done :)


local tileMetadata = Blendate("tiles/TileMetadata.json")

----------------TILES-----------------------

CLEAR.tiles.initTileSystem(tileMetadata, 6, 6)
CLEAR.tiles.addTile("tiles/Corner1", 0, 0, 0)
CLEAR.tiles.addTile("tiles/Wall1", 0, 1, 1)
CLEAR.tiles.addTile("tiles/Wall1", 1,0, 0)
CLEAR.tiles.addTile("tiles/Floor1", 1, 1, 0)
CLEAR.tiles.addTile("tiles/DeadEnd1", -1, 1, 0)
CLEAR.tiles.addTile("tiles/Floor1", -2, 1, 0)
CLEAR.tiles.addTile("tiles/Floor1", -2, 0, 0)
CLEAR.tiles.addTile("tiles/Wall1", -1, 0, 0)
CLEAR.tiles.addTile("tiles/Floor1", -2, -1, 0)
CLEAR.tiles.addTile("tiles/Floor1", -1, -1, 0)
CLEAR.tiles.addTile("tiles/Floor1", 0, -1, 0)
CLEAR.tiles.addTile("tiles/Floor1", 1, -1, 0)
CLEAR.tiles.addTile("tiles/Floor1", -3, -1, 0)
CLEAR.tiles.addTile("tiles/Floor1", -3, -2, 0)
CLEAR.tiles.addTile("tiles/Floor1", -3, 0, 0)

--CLEAR.char.new("template")

function pd.update()
    gfx.clear()

    CLEAR.update() --- all in one update function for the framework, feel free to modify this if you want

end