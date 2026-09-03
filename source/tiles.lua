import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"


local pd = playdate
local gfx = playdate.graphics

CLEAR.tiles = {}
--CLEAR.tiles.actions = {}

CLEAR.tiles.tilew, CLEAR.tiles.tileh, CLEAR.tiles.ySquish = 43, 43, 0.7 -- the default values

CLEAR.tiles.isInit = false

function CLEAR.tiles.initTileSystem(metadata, w, h)  -- this basically just       (half finished thought that I'm to lazy to remove)
    if metadata == nil then
        if CLEAR.tiles.metadata == nil then
            print("no metadata!")
        end
    else
        CLEAR.tiles.metadata = Blendate(metadata)
    end
    CLEAR.tiles.tilesArr, CLEAR.tiles.tileList = {}, {}
    CLEAR.tiles.centerX, CLEAR.tiles.centerY = math.ceil(w / 2), math.ceil(h / 2)
    for i = 1, w do
        CLEAR.tiles.tilesArr[i] = {}
        for x = 1, h do
            CLEAR.tiles.tilesArr[i][x] = {}
        end
    end
    CLEAR.tiles.tileMapW, CLEAR.tiles.tileMapH = w, h
    CLEAR.tiles.isInit = true
end

function CLEAR.tiles.clearTileSystem()
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    CLEAR.tiles.metadata = nil
    CLEAR.tiles.tilesArr, CLEAR.tiles.tileList = {}, {}
    CLEAR.tiles.centerX, CLEAR.tiles.centerY = nil, nil
    CLEAR.tiles.tileMapW, CLEAR.tiles.tileMapH = nil, nil
    CLEAR.tiles.isInit = false
end

function CLEAR.tiles.sortTiles()
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    table.sort(CLEAR.tiles.tileList, function (tile1, tile2)
        if tile1[3] < tile2[3] then 
            return true 
        else 
            return false 
        end
    end)
end

function CLEAR.tiles.addTile(path, tx, ty, rot, doReplace)
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    if not (CLEAR.tiles.tilesArr[tx + CLEAR.tiles.centerX][ty + CLEAR.tiles.centerY].img == nil) then
        if doReplace and #CLEAR.tiles.tileList > 0 then
            for x = 1, #CLEAR.tiles.tileList do
                if (CLEAR.tiles.tileList[x][1] == (tx + CLEAR.tiles.centerX)) and (CLEAR.tiles.tileList[x][2] == (ty + CLEAR.tiles.centerY)) then
                    table.remove(CLEAR.tiles.tileList, x)
                    CLEAR.tiles.tilesArr[tx + CLEAR.tiles.centerX][ty + CLEAR.tiles.centerY] = {} -- only clearing the tile array if it can be found, a very small optimization.
                    break
                end
            end
        else
            print("A tile already exists at " .. tx .. ", " .. ty .. "!")
            return
        end
    end
    local tempTile = {
        img = CLEAR.tiles.metadata:loadRotation(path),
        --tx = tx,
        x, ------ for the temp calculations each frame
        y, ------ ^^^
        frame, -- ^^^
        dist,
        hidden = false,
        on = {},
        ty = ty,
        rot = rot * 90,
        dx = tx,
        dy = ty
    }
    tempTile.w, tempTile.h = tempTile.img[1]:getSize()

    table.insert(CLEAR.tiles.tileList, {tx + CLEAR.tiles.centerX, ty + CLEAR.tiles.centerY, 0, 0})
    CLEAR.tiles.tilesArr[tx + CLEAR.tiles.centerX][ty + CLEAR.tiles.centerY] = tempTile
end

function CLEAR.tiles.removeTile(tx, ty)
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end

    for x = 1, #CLEAR.tiles.tileList do
        if (CLEAR.tiles.tileList[x][1] == (tx + CLEAR.tiles.centerX)) and (CLEAR.tiles.tileList[x][2] == (ty + CLEAR.tiles.centerY)) then
            table.remove(CLEAR.tiles.tileList, x)
            CLEAR.tiles.tilesArr[tx + CLEAR.tiles.centerX][ty + CLEAR.tiles.centerY] = {}
            return
        end
    end
    print("tile at x: " .. tx .. ", y: " .. ty .. " could not be removed because it could not be found")
end

function CLEAR.tiles.computeTiles()
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    local radAngle = math.rad(CLEAR.rotation * -1)
    CLEAR.sin = math.sin(radAngle)
    CLEAR.cos = math.cos(radAngle)
    local tempTile
    for i = 1, #CLEAR.tiles.tileList do
        --- a bunch of math :/
        tempTile = CLEAR.tiles.tilesArr[CLEAR.tiles.tileList[i][1]][CLEAR.tiles.tileList[i][2]]
        tempTile.frame = (math.floor((CLEAR.rotation + tempTile.rot) / 2) + 1) % 180 + 1
        tempTile.x, tempTile.y = ((tempTile.dx * CLEAR.cos - tempTile.dy * CLEAR.sin) * CLEAR.tiles.tilew) + 200 - 32, ((tempTile.dy * CLEAR.cos + tempTile.dx * CLEAR.sin) * CLEAR.tiles.tileh * CLEAR.tiles.ySquish) + 120 - tempTile.h + 32
        tempTile.dist = math.floor((tempTile.dy * CLEAR.cos + tempTile.dx * CLEAR.sin) * 10000)
        CLEAR.tiles.tileList[i][3] = tempTile.dist
    end
    CLEAR.tiles:sortTiles()
end

function CLEAR.tiles.drawObject(obj, parentTile)
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    if obj[1] == "char" then
        CLEAR.char.chars[obj[2]]:draw(parentTile)
    else 
        print("unsupported object type: " .. obj[1])
    end
end

function CLEAR.tiles.drawTiles()
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    local tempTile
    for i = 1, #CLEAR.tiles.tileList do
        --- a bunch of drawing :3
        tempTile = CLEAR.tiles.tilesArr[CLEAR.tiles.tileList[i][1]][CLEAR.tiles.tileList[i][2]]
        if not tempTile.hidden then
            tempTile.img[tempTile.frame]:draw(tempTile.x, tempTile.y)
            if CLEAR.tiles.tilesArr[CLEAR.tiles.tileList[i][1]][CLEAR.tiles.tileList[i][2]].on[1] ~= nil then
                CLEAR.tiles.drawObject(CLEAR.tiles.tilesArr[CLEAR.tiles.tileList[i][1]][CLEAR.tiles.tileList[i][2]].on[1], CLEAR.tiles.tilesArr[CLEAR.tiles.tileList[i][1]][CLEAR.tiles.tileList[i][2]])
            end
        end
    end
end

--- tile attribute functions

function CLEAR.tiles.hideTile(tx, ty, value) 
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    CLEAR.tiles.tileArr[tx][ty].hidden = value
end

function CLEAR.tiles.isHidden(tx, ty) 
    if not CLEAR.tiles.isInit then
        print("TileSystem not initialized! \nuse CLEAR.tiles.initTileSystem() before this runs to fix this!")
        return
    end
    return CLEAR.tiles.tileArr[tx][ty].hidden
end

