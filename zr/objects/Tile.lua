local DrawAble = require("interfaces/DrawAble")
local Game = require("Game")
--local Utils = require("utils")
local Window = require("uilib/Window")

---@class Tile: DrawAble
---@field x number
---@field y number
---@field width number
---@field height number
---@field rotation number
---@field scale_x number
---@field scale_y number
---@field origin_x number
---@field origin_y number
---@field image love.Image
---@field building Building|nil
local Tile = {
  __cls = Tile,
  __name = "Tile",
  instances = {},
  instancesAsList = {},
  tileSize = 32,
  images = {},
  tileWindow = nil,
}
Tile.__index = Tile

Tile.images["gras"] = love.graphics.newImage("images/tile/gras.png")

Tile.getTileAt = function(x, y)
  assert(type(x) == "number", "x must be a number")
  assert(type(y) == "number", "y must be a number")
  assert(x >= 0 and y >= 0, "Tile.getTileAt: x and y must be >= 0")
  local _x = math.floor(x / Tile.tileSize) * Tile.tileSize
  local _y = math.floor(y / Tile.tileSize) * Tile.tileSize
  local x_row = Tile.instances[_x]
  if x_row == nil then
    print(
      "Tile.getTileAt: x_row is nil at x: "
        .. _x
        .. " There is not tile at this x at all"
    )
    return nil
  end
  local tile = x_row[_y]
  if tile == nil then
    print(
      "Tile.getTileAt: tile is nil at x: "
        .. _x
        .. "  y: "
        .. _y
    )
    return nil
  end
  return tile
end

function Tile.drawAllTiles()
  for key, tile in ipairs(Tile.instancesAsList) do
    DrawAble.draw(tile)
  end
end

--- Updates all tiles, called in Game.update
--- @param dt number
--- @return nil
--- @see Game.update
function Tile.updateAllTiles(dt)
  -- if we click on a tile this tile is selcted

  if love.mouse.isDown(1) then
    if Game.mouseOverUI then
      return
    end
    print("TODO: Open context menu")
    --todo
  end

  if love.mouse.isDown(1) then
    -- if the mouse is over ui, we do not want to select a tile
    if Game.mouseOverUI then
      return
    end

    local x, y = love.mouse.getPosition()
    x = x + Game.getCurrentScreenFactorX()
    y = y + Game.getCurrentScreenFactorY()

    if Game.isOutsideWorld(x, y) == false then
      local tile = Tile.getTileAt(x, y)
      if Game.selectedTile then
        Game.selectedTile.rect = false
      end
      Game.selectedTile = tile
      Game.selectedTile.rect = true

      local w = Window.new(
        100,
        100,
        200,
        200,
        "Tile " .. tile.x .. " - " .. tile.y
      )
      w:addTextElement(tile:toString())

      if Tile.tileWindow then
        w.x = Tile.tileWindow.x
        w.y = Tile.tileWindow.y
        Tile.tileWindow:close()
      end
      Tile.tileWindow = w

      w.onClose = function()
        Tile.tileWindow = nil
        Tile.selectedTile = nil
      end

    end -- Game.isOutsideWorld(x, y) == false

  end -- if love.mouse.isDown(1)

end

function Tile.new(x, y, width, height)
  assert(x % Tile.tileSize == 0, "x is not a multiple of tileSize")
  assert(y % Tile.tileSize == 0, "y is not a multiple of tileSize")
  local self = setmetatable({}, Tile)
  Tile.instances[x] = Tile.instances[x] or {}
  Tile.instances[x][y] = self
  table.insert(Tile.instancesAsList, self)
  self.image = Tile.images["gras"]
  self.building = nil
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.rotation = 0
  self.scale_x = 1
  self.scale_y = 1
  self.origin_x = 0
  self.origin_y = 0
  self.walkable = true
  self.rect = false
  self.rectColor = { 0, 0, 0, 0 }
  self.units = {}
  return self
end

function Tile:isPassable()
  if self.building then
    --- todo: later on with more stories this becomes more complex
    return false
  end
  return self.walkable
end

--- Returns a short string representation of this tile.
--- @return string A short representation of the tile
function Tile:toString()
  if self.building ~= nil then
    return (
      "Tile: "
        .. self.x
        .. " "
        .. self.y
        .. " with building: "
        .. self.building:toString()
    )
  end
  return "Tile: " .. self.x .. " " .. self.y
end

return Tile