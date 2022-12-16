local DrawAble = require("interfaces/DrawAble")
local Tile = require("objects/Tile")
--[[
  Who needs multiplayer, is he can get agent based ai?
]]

--- @class Unit: DrawAble A agent. The agent performs tasks and makes descisions.
---       The player can issue commands, but the units do not follow blindly,
---       they decide a lot on their own.
---@field image love.Image
---@field x number
---@field y number
---@field width number
---@field height number
---@field rotation number
---@field scale_x number
---@field scale_y number
---@field origin_x number
---@field origin_y number
---@field current_tile Tile|nil

local Unit = {
  instances = {},
  instancesAsList = {},
  counter = 0,
  images = {
    agentr = love.graphics.newImage("images/units/agentr.png"),
    agentb = love.graphics.newImage("images/units/agentb.png")
  }
}
Unit.__index = Unit

function Unit.new(
  x,
  y,
  faction
)
  local self = setmetatable({}, Unit)
  Unit.counter = Unit.counter + 1
  Unit.instances[Unit.counter] = self
  table.insert(Unit.instancesAsList, self)
  self.id = Unit.counter
  self.x = x
  self.y = y
  self.width = 32
  self.height = 32
  self.rotation = 0
  self.scale_x = 1
  self.scale_y = 1
  self.origin_x = 0
  self.origin_y = 0
  self.draw_factor_y = 0
  self.image = Unit.images.agentr
  self.decision_interval = 0.5
  -- set this to random, so even if we create 200 units at once
  -- they don't all make a decision at the same time
  self.time_since_last_decision = math.random() * self.decision_interval

  self.target_x = self.x
  self.target_y = self.y
  self.commands = {} -- a list of commands, the unit tries to execute them
  self.faction = faction -- the faction this unit belongs to
  self.current_tile = Tile.getTileAt(self.x, self.y)
  self.current_tile.units[#self.current_tile.units + 1] = self
  assert(self.current_tile ~= nil, "Unit.new: current_tile is nil")
  return self
end

function Unit:makeDecision()

  -- if there is another unit on the tiles in proximity, make his tile the target


  -- move to a random tile
  local chance_of_changing_target = 0.1
  if math.random() < chance_of_changing_target then
    local tile
    repeat
      tile = Tile.instancesAsList[math.floor(math.random(#Tile.instancesAsList))]
    until tile and tile:isPassable()
    self.target_x = tile.x
    self.target_y = tile.y
  end
end

function Unit:update(dt)
  self.time_since_last_decision = self.time_since_last_decision + dt
  if self.time_since_last_decision > self.decision_interval then
    self.time_since_last_decision = 0
    self:makeDecision()
  end
  -- move towards target
  self:moveTowardsTarget(dt)
  -- todo: here check other logic like dying or doing actions
end

--- Move the unit towards the target
function Unit:moveTowardsTarget(dt)
  --todo: apply the navigation based on passable here
  local speed = 100
  local dx = self.target_x - self.x
  local dy = self.target_y - self.y
  local distance = math.sqrt(dx * dx + dy * dy)
  if distance > 0 then
    local move_x = dx / distance * speed * dt
    local move_y = dy / distance * speed * dt
    self.x = self.x + move_x
    self.y = self.y + move_y
  end
  local possible_new_tile = Tile.getTileAt(self.x, self.y)
  if self.current_tile ~= possible_new_tile then
    for index, unit in ipairs(self.current_tile.units) do
      if unit == self then
        table.remove(self.current_tile.units, index)
        break
      end
    end
    self.current_tile = possible_new_tile
    self.current_tile.units[#self.current_tile.units + 1] = self
    assert(self.current_tile ~= nil, "Unit.update: current_tile is nil")
  end

  -- for debug reasons: loop through all tiles and check if this unit is
  -- in the units list of exact one tile
  if debug then
    local found = false
    for _, tile in ipairs(Tile.instancesAsList) do
      for _, unit in ipairs(tile.units) do
        if unit == self then
          assert(not found, "Unit.update: unit is in multiple tiles")
          found = true
        end
      end
    end
    assert(found, "Unit.update: unit is not in any tile")
  end

end

function Unit.updateAllUnits(dt)
  for key, unit in ipairs(Unit.instances) do
    unit:update(dt)
  end
end

function Unit.drawAllUnits()
  for key, unit in ipairs(Unit.instancesAsList) do
    DrawAble.draw(unit)
  end
end

return Unit