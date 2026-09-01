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
character.x = 1
character.y = 1
character.drawx, character.drawy = 0, 0
character.blendData = Blendate("char/" .. name .. "/metadata.json")
character.anims = {}
character.anims.idle = {character.blendData:loadRotation("char/" .. name .. "/Player"), 1, 0} --put the path to the idle anim also the second value is the length of the anim in frames and the third is the height which you set afterwards
character.anims.idle[3] = character.anims.idle[1][1]:getSize()
-- if its a static rotation with no animation keep this the same, otherwise read https://osuika.games/blendate#lua and figure it out until I learn to animate and actially test/implement this. :)

--note to whoever is using this you need to maybe write your own anim controller :3 (if you are not reading this then I already implemented it)

character.currAnim = "idle"

--- put your update stuff here ig
function character.update(self) --use the global CLEAR which has all of the tile data/functions and loaded character data and such :b
    print("yo i'm being updated!!!! :3")
    --- I recommend doing all of the position calculations BEFORE the drawing function just to keep it all smooth
    self.drawx, self.drawy = ((self.x * CLEAR.cos - self.y * CLEAR.sin) * CLEAR.tiles.tilew) + 200 - 32, ((self.y * CLEAR.cos + self.x * CLEAR.sin) * CLEAR.tiles.tileh * CLEAR.tiles.ySquish) + 120 - character.anims[character.currAnim][3] + 32
    print(CLEAR.sin, CLEAR.cos)
    print(self.drawx ..", " .. self.drawy)
end

function character.draw(self, parent)
    ---you should probably draw here, unless your character is the invisible man, in which case do whatever you want
    printTable(self)
    gfx.imagetable.getImage(self.anims.idle[1], math.max(math.ceil((CLEAR.rotation) / 2), 1)):draw(self.drawx, self.drawy)
    print(self.drawx ..", " .. self.drawy)
end

return character
