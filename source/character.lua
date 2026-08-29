import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

------------- TODOS ----------------
---Figure out config

local pd = playdate
local gfx = playdate.graphics

local char = {}
char.chars = {}


function char.new(config) -- config is an array that holds anims, abilities, and other stuff that will be loaded dynamically
    if char.chars[config.name] ~= nil then
        return nil
    end
    char.chars[config.name] = config
    table.insert(CLEAR.tiles.tileArr[config.x][config.y].on, {char, config.name})
    table.insert(char.charList, config.name)
end

function char.update(self)
    for i = 1, #self.charList do
        self.chars[self.charList[i]]:update(self, CLEAR)
    end
end

-- ok.... so I guess I have to draw characters based on their position.. FU
--- Ok now I just gotta make every character have a tileslot and when their time comes, draw them during the tile draw phase right after the tile they're standing on gets drawn and the profit!
CLEAR.char = char