import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd = playdate
local gfx = playdate.graphics

local name = "template"

local character = {}
character.name = name
character.x = 6
character.y = 6
--- Anims and stuff ---
character.blendData = Blendate("char/" .. name .. "/metadata.json")
character.anims = {}
character.anims.idle = {character.metadata:loadRotation("char/" .. name .. "/player"), 1} --put the path to the idle 1-frame  also the second value is the length of the anim
--note to whoever is using this you need to maybe write your own anim controller :3

character.currAnim = "idle"

--- put your update stuff here ig
function character.update(self, clear) --the clear input array holds all the tile functions and character data along with everything else that's split up into files, I give you this so you can read the tilemap state and such :)
    
end


return character
