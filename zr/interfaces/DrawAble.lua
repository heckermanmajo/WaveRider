local Game = require("Game")


---@class DrawAble
---@field public draw function
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


function isDrawAble(instance)
  -- todo: check for the existence of functions and variables
  return true
end

local Drawable = {}

function Drawable.draw(instance)
  isDrawAble(instance)
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