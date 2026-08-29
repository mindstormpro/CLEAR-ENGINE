import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd = playdate
local gfx = playdate.graphics

local clear = {}

clear.state = "planning" -- Could be "planning" or "action", where action is where stuff happens in real time and planning is where you decide your moves

CLEAR = clear