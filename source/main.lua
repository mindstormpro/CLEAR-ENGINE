import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import("blendate")


local pd = playdate
local gfx = playdate.graphics
local tmr = pd.timer
import("clear")  
import("tiles")

--- TODOs:
--- add dynamic loading                      TODO, URGENT, TOO LAZY
--- make modding framework                   TODO, URGENT, AGAIN, I'M TOO LAZY       I need to do this soon since if I do it later it will be hard to implement around everything else (use the loadPDZ function)
--- Rewrite the blendate.lua script          basically not needed anymore, so done :)

math.randomseed(playdate.getSecondsSinceEpoch())

local tileMetadata = Blendate("tiles/TileMetadata.json")


----------------TILES-----------------------

CLEAR.tiles.initTileSystem(tileMetadata, 7, 5)


--CLEAR.char.new("template") this is how you would create a new character but its not done sooo...

local function fillTiles()
    local tiles = {
        "tiles/DeadEnd1",
        "tiles/Corner1",
        "tiles/Floor1",
        "tiles/Floor1",
        "tiles/Floor1",
        "tiles/Wall1",
        "tiles/Wall1"
    }
    for x = -3, 3 do
        for y = -2, 2 do
            if math.random(1, 5) > 1 then
                local tile = tiles[math.random(1, 7)]
                CLEAR.tiles.addTile(tile, x, y, math.random(0, 3), false)
            end
        end
    end
end

fillTiles()

function pd.update()
    gfx.clear()
    pd.timer.updateTimers()
    CLEAR.update() --- all in one update function for the framework, feel free to modify this if you want

end