import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"


local pd = playdate
local gfx = playdate.graphics

CLEAR.tiles = {}
local tiles = {}


tiles.tilew, tiles.tileh, tiles.ySquish = 43, 43, 0.7
local centerX, centerY = 5, 5



function tiles.initTileSystem(metadata, w, h, cx, cy)  -- this basically just       (half finished thought that I'm to lazy to remove)
    if metadata == nil then
        if CLEAR.tiles.metadata == nil then
            print("no metadata!")
        end
    else
        CLEAR.tiles.metadata = metadata
    end
    CLEAR.tiles.tilesArr, CLEAR.tiles.tileList = {}, {}
    CLEAR.tiles.centerX, CLEAR.tiles.centerY = cx, cy
    for i = 1, w do
        CLEAR.tiles.tilesArr[i] = {}
        for x = 1, h do
            CLEAR.tiles.tilesArr[i][x] = {}
        end
    end
end

function tiles.sortTiles()
    table.sort(CLEAR.tiles.tileList, function (tile1, tile2)
        
        if tile1[3] < tile2[3] then 
            return true 
        else 
            return false 
        end
    end)
end

function tiles.addTile(path, tx, ty, rot)
    if not (CLEAR.tiles.tilesArr[tx][ty].img == nil) then
        print("A tile already exists at " .. tx .. ", " .. ty .. "!")
        return
    end
    local tempTile = {
        img = CLEAR.tiles.metadata:loadRotation(path),
        tx = tx,
        x, ------ for the temp calculations each frame
        y, ------ ^^^
        frame, -- ^^^
        dist,
        on = {},
        ty = ty,
        rot = rot * 90,
        dx = tx - CLEAR.tiles.centerX,
        dy = ty - CLEAR.tiles.centerY
    }
    tempTile.w, tempTile.h = tempTile.img[1]:getSize()
    print(tempTile.w / 2)
    table.insert(CLEAR.tiles.tileList, {tx, ty, 0, 0})
    CLEAR.tiles.tilesArr[tx][ty] = tempTile
end

function tiles.computeTiles()
    local crankAngle =  pd.getCrankPosition()
    local radAngle = math.rad(crankAngle * -1)
    local sin = math.sin(radAngle)
    local cos = math.cos(radAngle)
    local tempTile
    for i = 1, #CLEAR.tiles.tileList do
        --- a bunch of math
        tempTile = CLEAR.tiles.tilesArr[CLEAR.tiles.tileList[i][1]][CLEAR.tiles.tileList[i][2]]
        tempTile.frame = (math.floor((crankAngle + tempTile.rot) / 2) + 1) % 180 + 1
        tempTile.x, tempTile.y = ((tempTile.dx * cos - tempTile.dy * sin) * CLEAR.tiles.tilew) + 200 - 32, ((tempTile.dy * cos + tempTile.dx * sin) * CLEAR.tiles.tileh * CLEAR.tiles.ySquish) + 120 - tempTile.h + 32
        tempTile.dist = math.floor((tempTile.dy * cos + tempTile.dx * sin) * 10000)
        tiles.tileList[i][3] = tempTile.dist
    end
    CLEAR.tiles:sortTiles()
end

function tiles.drawTiles()
    local tempTile
    for i = 1, #CLEAR.tiles.tileList do
        --- a bunch of drawing :3
        tempTile = CLEAR.tiles.tilesArr[CLEAR.tiles.tileList[i][1]][CLEAR.tiles.tileList[i][2]]
        tempTile.img[tempTile.frame]:draw(tempTile.x, tempTile.y)
    end
end

CLEAR.tiles = tiles