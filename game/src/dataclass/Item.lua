--[[
    Item should replace ammo, medikit und money classes.
    All items are also inventory items.
]]

--- @class Item
--- @field instances Item[]
--- @field  x
--- @field  y
--- @field  w
--- @field  h
--- @field  amount
--- @field  texture
--- @field  pickup_sound
--- @field  type
--- @field  pickup_callback function needs to take self

local Item = {
  instances = {}
}

-- Constructor for an item
function Item:new(
  x,
  y,
  w,
  h,
  amount,
  texture,
  pickup_sound,
  type,
  pickup_callback
)
  local this = {}
  this.x = x
  this.y = y
  this.w = w
  this.h = h
  this.amount = amount
  this.texture = texture
  this.pickup_sound = pickup_sound
  this.type = type
  this.pickup_callback = pickup_callback

  table.insert(self.instances, this)
  setmetatable(this, self)
  self.__index = self
  return this
end

return Item