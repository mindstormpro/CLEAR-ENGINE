# CLEAR-ENGINE! 

## What's CLEAR-ENGINE?
CLEAR-ENGINE is a **Framework/Library** for making playdate games, specifically **turn-based 3d strategy games!\*** It uses a very simple API (see [The API!](Docs/API.md)) 
> *Note, Right now only the base engine and renderer have been released, the interaction and character libraries will come in the future. You can still make 3D turn-based stratagy games though, or really any 3D tile-based game with this library!  

<img width="800" height="480" alt="playdate-20260901-091758" src="https://github.com/user-attachments/assets/eb53a8fe-ac89-4a49-a168-db7ded9c36e3" />
 
I plan to release the engine in three parts, The Renderer (out now!), The Character System, and The Action System.  
Right now The Render is done, and is the core component that everything will be based on, so I am shipping it now!  
(also, if you really wanted you could totally use this to make like a top-down RPG or some sort of similar game with the 3D engine, but it is made with turn-based strategy in mind)  
Cool/notable features:
 - rendering of stuff in three whole Ds (never before seen)
 - all written in lua and VERY preformant (stable 30FPS when running on-device with rotations)
 - An included modified version of Blendate.lua (with permission) integrated directly into the engine for easy importing of tiles/objects/characters. (thanks osuika!!💛)

## **SHIPWRIGHTERS PLEASE READ**
CLEAR-ENGINE is a library. There are no package managers made for the playdate, so you have to import the framework manually to try it. I have provided a prebuilt demo, but it can only be ran with the playdate simulator installed (a close-source proprietary piece of software that I cannot bundle into the release) or by uploading it to the console and trying it out that way, but you obviously need to own one. There is no way for me to make the demo an executable, you NEED to download the simulator to test it without a console (don't worry though, it's free!)
You can download it [HERE](https://play.date/dev)
## Backstory
CLEAR was gonna be a tactical turn-based strategy game where you clear (heh-heh) rooms of a level one-by-one by controlling the actions each character makes.  

sadly, reality set in and I realized two things:
 - This is not something I can feasably do in a month for the stardance chalenge
 - I'm buns at art

So now I have decided to just focus on the code aspect, and release it as CLEAR-ENGINE, an easy to use framework that allows you to make cool turn-based games with a simple 3D rendering engine!

Also I do plan to actually make CLEAR, but I'm just making CLEAR-ENGINE first because why not

## How I made this really really cool project:
I made this project through a long, annoying, and yet still really fun journy:
 - After I got the idea to make a framework for this, I did a bunch of research!
   - I did some research, and eventually I stumbled apon [This Awesome Devlog](https://dioragame.com/devlog/?log=3) for a game called Diora, and their rendering engine was very similar to what I wanted
   - I also used AI to help me wrap my head around some of the maths that make the engine only need to calculate sine and cosine once per frame, and also I spent like a solid 2 weeks just brainstorming how I might structure the engine.
 - Then I started the actual programming of the engine
   - originally during this part, I just threw all of the code into `main.lua` and after like 5 hours I had a working-ish renderer that made all the tiles show properly on the screen.
   - I also added distance calculation from the camera in order to sort them in a way that the tiles closest to the camera always render last, so tiles don't overlap in wierd ways.
   - It was also around this time when I met the developer of Blendate, a tool used to turn 3D blender models into imagetables that you can use for the playdate so you don't have to actually render 3D models and can instead render images, and this genuinely saved this project because without it I would have to actually rasterize the tiles to the screen and apply textures, and that's just not feasable in lua on this console, so big thanks to him for giving me a free copy of his tooling and letting me include his importer, `source/blendate.lua`, in this project :3.
 - After getting the renderer to... well... render, I embarked on the painful task of somehow structuring my bad code into an engine that is usable. 
   - I moved all of the general code and the main updater loop for the engine into the `source/clear.lua` file, and made that the center of the engine, because it calls all the updater functions of all the other libraries and makes everything work together.
   - I also moved the renderer into `source/tiles.lua`, and put everything into more user-friendly functions that could be called instead of having to paste a giant blob of code to make a tile appear. This part wasnt that bad compared to the rest of the project, as the only real timesink was making everything somewhat readable, since all of the main code already exists and it was really just a factor of how hard is it to move code from A to B without breaking it.
 - After I had a working demo again, but this time with all of the engine code in their own self-contained libraries, I spent time adding some QoL functions that I didn't nesicarily need at the moment but would be useful in the future, like `CLEAR.tiles.hideTile()` in `source/tiles.lua` for hiding a tile, or `CLEAR.tiles.clearTileSystem()`, also in `source/tiles.lua`, for clearing all tiles off the tilesystem.
 - Then at that point all there was left to do to get to the point where I am now was to do docs!
   - I wrote some basic API documentation in [Docs/API.md](Docs/API.md) that covers all of the current API, including but not limited to creating tiles, deleting tiles, and setting their attributes such as `isHidden`. This only took me like 2 hours, since I just made a simple function template and copy-pasted it for each function before filling in the details, and this had the bonus affect of making the API standardised, so all API functions have the exact same setup in the docs for easy readablilty.

## How To use the demo!
 * Download the playdate sdk at [https://play.date/dev](https://play.date/dev) and run the simulator that it installs 
 * then download the latest demo.pdx.zip file from the releases, unzip it, and then open the demo.pdx folder with the playdate simulator
 * Profit!

 ## How to use the framework!
  * Download the latest `BaseEngine.zip` from releases and unzip it, then shove the whole thing into your source folder.
  * Import it using `import "clear"` and then import each submodule you want to use, for now there is only the `tiles` submodule so you would do `import "tiles"` right after.
  * Then read the API docs in the docs folder to understand how to use it and look at the main.lua in the repo for an example of usage.
Here's a simple `main.lua` that sets up the world, and creates small 2x2 room, along with allowing the user to rotate the scene with the crank.
```lua
-- import the base libraries needed for the engine
import "CoreLibs/object"
import "CoreLibs/graphics"
import("blendate")

-- common shorthand
local pd = playdate
local gfx = playdate.graphics
local tmr = pd.timer

-- actually import the engine along with the tile subsystem
import("clear")
import("tiles")

-- initialize/create the tilesystem.
-- The first arg points to the tile's 3D model metadata location, generated by blendate, and the other two are the width and height of the tilesystem
CLEAR.tiles.initTileSystem("tiles/TileMetadata.json", 7, 5)

-- this function places a floor tile at (0, 0) on the tilesystem, the third 0 is the tile rotation, and the boolean at the end is the DoReplace modifier, all it does is tell CLEAR whether or not it's ok to replace a tile if one already exists there.
CLEAR.tiles.addTile("tiles/Floor1", 0, 0, false)

-- now we do it 3 more times :)
CLEAR.tiles.addTile("tiles/Wall1", 1, 0, 0, false)
CLEAR.tiles.addTile("tiles/Wall1", 0, 1, 0, false)
CLEAR.tiles.addTile("tiles/Corner1", 1, 1, 0, false)

function pd.update() -- this function is the backbone of all playdate games, it gets called every frame
  CLEAR.rotation = pd.getCrankPosition() -- update the engine's scene rotation
  gfx.clear() -- clear the screen :)
  CLEAR.update() --- all in one update function for the framework, it calculates the tile states and positions, and then draws everything in order
```
so far I have tested tileSystem sizes as big as 10 by 10, and I have had no preformance issues on-device. The only real preformance hiccups come from loading new tiles into the world, since the device has to haul a whole imagetable and a bunch of metadata into ram, which is a pain for the CPU, so don't try loading tiles during something important, because the lag spikes last upwards of 0.2 seconds.

## Roadmap:
This project is very large, and I plan to ship it in the following segments:
 - The Base Library: `source/clear.lua` (DONE)
   - Provides the basic foundation for every piece after it
   - Provides a consistant format for the way the engine data is structured so other pieces can work with eachother easily
 - The Tiles Library: `source/tiles.lua` (DONE)
   - Gives 3D tile rendering functionality (duh)
   - Has native support for defining custom objects to be rendered in the pipeline, so people can add things like assets that sit on top of tiles, if they want to program that (also used by other pieces like the character renderer)
 - The Character Library: `source/character.lua` (IN PROGRESS)
   - Allows people to make characters with animations and properties that get rendered on top of tiles, essentially just sprites, but rendered in 3D, because their behavior is really up to the end user of the framework
   - Uses blendate-rendered models to render characters efficiently, just like the tile system, although you need to define animations in code yourself, otherwise they won't render properly.
 - The Interaction Library: (NOT STARTED)
   - This library allows custom Tactical-Breach-Wizards inspired interfaces with custom actions to be defined, so that the player can select and control all characters in the game easily
   - This library will also define a standard set of functions such as one to take over crank control or one to define a back and select keybind, ect for the user of the framework to easily create custom interactions, such as an aiming function for a spell or a spell that requires selecting multiple targets, and so on.

## AI DISCLOSURE:
AI did not to any Art, Sound Design, or any of the creative aspects of the framework/default assets. AI was used for understanding the math behind the rendering, but has never written any code for me. All code has been written by hand by me on a lenovo laptop using vscodium :3
