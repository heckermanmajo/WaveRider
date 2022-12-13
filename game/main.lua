--[[
  
  This is the main file for the wave rider games.

]]

function math.round(n, deci)
  deci = 10^(deci or 0)
  return math.floor(n*deci+.5)/deci
end

function int(n)
  return math.floor(n+.5)
end

-- load all basics
Utils = require "src/utils"


-- Load all dataclasses
Ammo = require "src/dataclass/ammo"
Zombie = require "src/dataclass/Zombie"
Bullet = require "src/dataclass/bullet"
Player = require "src/dataclass/player"
Tower = require("src/dataclass/tower")
FirstAid = require("src/dataclass/first_aid")
Money = require("src/dataclass/money")
Trooper = require("src/dataclass/trooper")
NonInteractionObject = require("src/dataclass/non_interaction_object")
Tile = require("src/dataclass/Tile")
Item = require("src/dataclass/Item")
Building = require("src/dataclass/Building")
Mob = require("src/dataclass/Mob")

--- require all protocols
CollisionProtocol = require("src/protocols/CollisionProtocol")
DrawProtocol = require("src/protocols/DrawProtocol")
FloatingProtocol = require("src/protocols/FloatingProtocol")
PickupProtocol = require("src/protocols/PickupProtocol")
LookAtProtocol = require("src/protocols/LookAtProtocol")

--- require all controller
NonInteractionObjectController = require("src/controller/non_interaction_object_controller")
ExplosionController = require("src/controller/explosion_controller")
PlayerAirStrikeController = require("src/controller/player_airstrike_controller")
MinimapController = require("src/controller/minimap_controller")
ZombieSpawnController = require("src/controller/zombie_spawn_controller")
ZombieWaveController = require("src/controller/zombie_wave_controller")
InventoryController = require("src/controller/inventory_controller")
PlayerPlaceBuildingsController = require("src/controller/player_place_buildings_controller")
MobController = require("src/controller/MobController")
DebugController = require("src/controller/debug_controller")
PlayerMovementController = require("src/controller/player_movement_controller")


-- load the game data (global game state)
GameData = require("game_data")

-- load all scenes
WaveGame = require("src/scenes/wave_game")
MainMenu = require("src/scenes/main_menu")

-- put stuff into the console
io.stdout:setvbuf('no')

local profile = require("lib/profile")

--[[
  LOVE LOAD
]]
function love.load()

  love.audio.setVolume(0.3)
  love.window.setFullscreen(true, "desktop")
  love.window.setVSync(1)

  print("Load resources ...")

  for name, val in pairs(GameData.textures) do
    for _name, path in pairs(GameData.textures[name]) do
      GameData.textures[name][_name] = love.graphics.newImage(
        GameData.textures[name][_name]
      )
      print("Loaded " .. name .. " from '" .. path .. "'")
    end
  end

  for name, val in pairs(GameData.sounds) do
    for _name, path in pairs(GameData.sounds[name]) do
      GameData.sounds[name][_name] = love.audio.newSource(
        GameData.sounds[name][_name], "static"
      )
      print("Loaded " .. name .. " from '" .. path .. "'")
    end
  end

  font = love.graphics.newImageFont(
    "images/font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
      "123456789.,!?-+/():;%&`'*#=[]\""
  )
  love.graphics.setFont(font)

  love.mouse.setCursor(GameData.cursor.cursor_target, 16, 16)
end


--[[
  UPDATE FUNCTION
]]

function love.update(delta_frame)

  if GameData.game_view_mode == "campaign" then
    print("Campaign is not there jet")
  elseif GameData.game_view_mode == "battle" then
    WaveGame.update(delta_frame)
  elseif GameData.game_view_mode == "main_menu" then
    MainMenu.update(delta_frame)
  end

end


function love.draw()

  if GameData.game_view_mode == "campaign" then

  elseif GameData.game_view_mode == "battle" then
    WaveGame.display(delta_frame)
  elseif GameData.game_view_mode == "main_menu" then
    MainMenu.display(delta_frame)
    love.graphics.print(tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("tostring(love.timer.getFPS())", 100, 10)
    love.graphics.print("tostring(love.timer.getFPS())", 100, 10)
  end

end
