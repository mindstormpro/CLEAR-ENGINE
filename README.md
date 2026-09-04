# CLEAR-ENGINE! 

## What's CLEAR-ENGINE?
CLEAR-ENGINE is a framework for making playdate games, specifically turn-based 3d strategy games! It uses a very simple API (see [The API!](docs/API.md)) 
<img width="800" height="480" alt="playdate-20260901-091758" src="https://github.com/user-attachments/assets/eb53a8fe-ac89-4a49-a168-db7ded9c36e3" />

I plan to release the engine in three parts, The Renderer, The Character System, and The Action System.  
Right now The Render is done, and is the core component that everything will be based on, so I am shipping it now!  
(also, if you really wanted you could totally use this to make like a top-down RPG or some sort of similar game with the 3D engine, but it is made with turn-based strategy in mind)  
Cool/notable features:
 - rendering of stuff in three whole Ds (never before seen)
 - all written in lua and VERY preformant (stable 30FPS when running on-device with rotations)
 - An included modified version of Blendate.lua (with permission) integrated directly into the engine for easy importing of tiles/objects/characters.

## Backstory
CLEAR was gonna be a tactical turn-based strategy game where you clear (heh-heh) rooms of a level one-by-one by controlling the actions each character makes.  

sadly, reality set in and I realized two things:
 - This is not something I can feasably do in a month for the stardance chalenge
 - I'm buns at art

So now I have decided to just focus on the code aspect, and release it as CLEAR-ENGINE, an easy to use framework that allows you to make cool turn-based games with a simple 3D rendering engine!

Also I do plan to actually make CLEAR, but I'm just making CLEAR-ENGINE first because why not

## How To use the demo!
 * Download the playdate sdk at [https://play.date/dev] and run the simulator that it installs
 * then download the latest demo.pdx.zip file, unzip it, and then open the demo.pdx folder with the playdate simulator
 * Profit!

 ## How to use the framework!
  * Download the latest `BaseEngine.zip` from releases and unzip it, then shove the whole thing into your source folder.
  * Import it using `import "clear"` and then import each submodule you want to use, for now there is only the `tiles` submodule so you would do `import "tiles"` right after.
  * Then read the API docs in the docs folder to understand how to use it and look at the main.lua in the repo for an example of usage.

## AI DISCLOSURE:
AI did not to any Art, Sound Design, or any of the creative aspects of the framework/default assets. AI was used for understanding the math behind the rendering, but has never written any code for me. All code has been written by hand by me.
