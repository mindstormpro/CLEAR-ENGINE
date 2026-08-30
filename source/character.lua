import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import("clear")
------------- TODOS ----------------
---Figure out config

local pd = playdate
local gfx = playdate.graphics

local char = {}
char.chars = {}

char.selectedChar = nil

char.charList = {}

function char.new(name) -- config is an array that holds anims, abilities, and other stuff that will be loaded dynamically
    print(name)
    printTable(CLEAR.config)
    local config = CLEAR.config.chars[name]
    if CLEAR.char.chars[config.name] ~= nil then
        print("oops this char already exists!")
        return nil
    end
    if CLEAR.tiles.tilesArr[config.x][config.y] == nil then
        print("hey waitaminute! you can't put " .. config.name .. "on " .. config.x ..", " .. config.y .. " because that tile doesn't actually exist!")
    end
    CLEAR.char.chars[config.name] = config
    
    table.insert(CLEAR.tiles.tilesArr[config.x][config.y].on, {"char", config.name})
    table.insert(CLEAR.char.charList, config.name)
end

function char.update()
    if #CLEAR.char.charList == 0 or #CLEAR.char.charList then --- #NeverNester
        return
    end

    for i = 1, #CLEAR.char.charList do
        CLEAR.char.chars[CLEAR.char.charList[i]]:update(CLEAR.char, CLEAR)
    end
end

-- ok.... so I guess I have to draw characters based on their position.. shoot
--- Ok now I just gotta make every character have a tileslot and when their time comes, draw them during the tile draw phase right after the tile they're standing on gets drawn and the profit!
--- wait characters might overlap with the walls and stuff, time to make variants of each and every wall tile that has half of each wall segment missing so that it draws properly... dammit
CLEAR.char = char