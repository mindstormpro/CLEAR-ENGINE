import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd = playdate
local gfx = playdate.graphics

CLEAR = {}

CLEAR.state = "planning" -- Could be "planning" or "action", where action is where stuff happens in real time and planning is where you decide your moves
CLEAR.rotation = 1

CLEAR.sin, CLEAR.cos = nil, nil

function CLEAR.update() ---Feel free to patch this function to update in your own way, I'm trying to make all of this framework easy to patch
    CLEAR.rotation = pd.getCrankPosition()

    CLEAR.tiles.computeTiles() --- computes the position of each tile, and sorts them based on distance (my brain lowkey cooking here (based))
    if CLEAR.char then
        CLEAR.char.update() --- runs every character's update function, or just the current selected one (I need to decide) NOT A DRAWING FUNCTION, SO IMAGINE LOVE2D 
    end
    CLEAR.tiles.drawTiles() --- actually draws the tiles in order and also draws the objects (such as players) on top of them when needed :3 
end

CLEAR.config = import("config")