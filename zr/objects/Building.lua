local DrawAble = require("interfaces/DrawAble")
local Tile = require("objects/Tile")
local Utils = require("utils")

local Building = {
  instances = {},
  textures = {}
}
Building.__index = Building

Building.textures["wall"] = love.graphics.newImage("images/building/wall.png")

Building.drawAllBuildings = function()
  for key, building in ipairs(Building.instances) do
    DrawAble.draw(building)
  end
end


function Building.new(tile)
  assert(tile ~= nil, "tile is nil")
  assert(tile.__name == "Tile" , "tile must be a Tile")
  assert(tile.building == nil, "tile already has a building")
  local self = setmetatable({}, Building)
  table.insert(Building.instances, self)
  self.image = Building.textures["wall"]
  self.id = #Building.instances
  self.x = tile.x
  self.y = tile.y
  self.width = tile.width
  self.height = tile.height
  self.rotation = 0
  self.scale_x = 1
  self.scale_y = 1
  self.origin_x = 0
  self.origin_y = 0
  self.draw_factor_y = -32 -- draw this 32 pixel upper

  self.onDestruction = nil
  self.onBuild = nil
  self.onClick = nil
  self.onMouseOver = nil
  self.onMouseOut = nil
  self.onDamage = nil
  self.onUpdate = nil

  tile.building = self
  print("Building.new: tile: " .. tile:toString())

  return self
end

function Building:toString()
  return "Building: " .. self.id
end

return Building