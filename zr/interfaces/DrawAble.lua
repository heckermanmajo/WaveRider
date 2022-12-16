local Game = require("Game")


---@class DrawAble
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


function checkDrawAble(instance)
  assert(instance ~= nil, "instance is nil")
  assert(instance.image ~= nil, "instance.image is nil")
  assert(instance.x ~= nil, "instance.x is nil")
  assert(instance.y ~= nil, "instance.y is nil")
  assert(instance.width ~= nil, "instance.width is nil")
  assert(instance.height ~= nil, "instance.height is nil")
  assert(instance.rotation ~= nil, "instance.rotation is nil")
  assert(instance.scale_x ~= nil, "instance.scale_x is nil")
  assert(instance.scale_y ~= nil, "instance.scale_y is nil")
  assert(instance.origin_x ~= nil, "instance.origin_x is nil")
  assert(instance.origin_y ~= nil, "instance.origin_y is nil")
  assert(type(instance.image) == "userdata", "instance.image must be a love.Image")
  assert(type(instance.x) == "number", "instance.x must be a number")
  assert(type(instance.y) == "number", "instance.y must be a number")
  assert(type(instance.width) == "number", "instance.width must be a number")
  assert(type(instance.height) == "number", "instance.height must be a number")
  assert(type(instance.rotation) == "number", "instance.rotation must be a number")
  assert(type(instance.scale_x) == "number", "instance.scale_x must be a number")
  assert(type(instance.scale_y) == "number", "instance.scale_y must be a number")
  assert(type(instance.origin_x) == "number", "instance.origin_x must be a number")
  assert(type(instance.origin_y) == "number", "instance.origin_y must be a number")
end

local Drawable = {}

function Drawable.draw(instance)
  checkDrawAble(instance)
  -- only draw if the instance is in the camera view
  if (instance.x+ instance.width)  * Game.scroll_factor< Game.getCurrentScreenFactorX() then
    return
  end
  if instance.x * Game.scroll_factor >  Game.getCurrentScreenFactorX()+ Game.screen_width then
    return
  end
  if (instance.y + instance.height) * Game.scroll_factor < Game.getCurrentScreenFactorY() then
    return
  end
  if instance.y * Game.scroll_factor > Game.getCurrentScreenFactorY() + Game.screen_height then
   return
  end

  local y_factor = instance.draw_factor_y or 0

  love.graphics.draw(
    instance.image,
    instance.x * Game.scroll_factor - Game.getCurrentScreenFactorX(),
    (instance.y + y_factor) * Game.scroll_factor - Game.getCurrentScreenFactorY(),
    instance.rotation,
    instance.scale_x * Game.scroll_factor,
    instance.scale_y * Game.scroll_factor,
    instance.origin_x,
    instance.origin_y
  )

  if instance.rect then
    --love.graphics.rectangle("line", instance.x, instance.y, instance.width, instance.height)
    love.graphics.rectangle(
      "line",
      instance.x * Game.scroll_factor - Game.getCurrentScreenFactorX()-1,
      instance.y * Game.scroll_factor - Game.getCurrentScreenFactorY()-1,
      instance.width * Game.scroll_factor +1,
      instance.height * Game.scroll_factor +1
    )
    --love.graphics.setColor(1, 1, 1, 1)
  end

end

return Drawable