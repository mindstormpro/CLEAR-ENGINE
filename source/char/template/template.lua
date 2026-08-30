import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import("blendate")

local pd = playdate
local gfx = playdate.graphics

local name = "template"

local character = {}
character.name = name
character.x = 6
character.y = 6

character.blendData = Blendate("char/" .. name .. "/metadata.json")
character.anims = {}
character.anims.idle = {character.blendData:loadRotation("char/" .. name .. "/Player"), 1} --put the path to the idle 1-frame  also the second value is the length of the anim
--note to whoever is using this you need to maybe write your own anim controller :3 (if you are not reading this then I already implemented it)

character.currAnim = "idle"

--- put your update stuff here ig
function character.update(self) --use the global CLEAR which has all of the tile data/functions and loaded character data and such :b
    print("yo i'm being updated!!!! :3")

end

function character.draw(self, parent)
    ---you should probably draw here, unless your character is the invisible man, in which case do whatever you want
    
end

return character
