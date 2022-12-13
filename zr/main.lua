local Tile = require("objects/Tile")
local Building = require("objects/Building")
local Utils = require("utils")
local World = require("World")
local Game = require("Game")
local SelectedElementUI = require("userinterface/SelectedElementUI")
local Window = require("uilib/Window")

function love.load()

  -- create a new world 800x600 by creating tiles
  for x = 0, Game.world_width, 32 do
    for y = 0, Game.world_height, 32 do
      Tile.new(x, y, 32, 32)
    end
  end

  -- create 10 buildings at random positions
  for i = 1, 100 do
    local x = math.random(0, Game.world_width)
    local y = math.random(0, Game.world_height)
    --print(Utils.dump(Tile.instances))
    print("x: " .. x .. " y: " .. y)
    local tile = Tile.getTileAt(x, y)
    assert(tile ~= nil, "tile is nil")
    if tile.building == nil then
      Building.new(tile)
    end
  end

  -- create a window
  local w1 = Window.new(100, 100, 200, 200, "Window 1")
  local w2 = Window.new(300, 300, 200, 200, "Window 2")

  w2:addTextElement("Hello World")
  w2:addTextElement("Hello World2")
  w2:addTextElement("Hello World3")

end


function love.update(dt)
  Game.mouseOverUI = false
  Window.updateAll(dt) -- update the windows before the Game (drag)
  Tile.updateAllTiles()
  Game.update(dt)
end

function love.draw()

  Tile.drawAllTiles()
  Building.drawAllBuildings()
  SelectedElementUI.displayUI()
  Window.drawAll()

end