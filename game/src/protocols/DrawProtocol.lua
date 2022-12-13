---@class DrawEntity
---@field x number
---@field y number
---@field rotation number
---@field texture table


--- Simple Protocol for drawing entities
---@param entity DrawEntity
function DrawProtocol(entity)

  assert(type(entity.x) == "number", "DrawEntity misses 'x' or 'x' is no Number")
  assert(type(entity.y) == "number", "DrawEntity misses 'y' or 'y' is no Number")
  assert(type(entity.rotation) == "number", "DrawEntity misses 'rotation' or 'rotation' is no Number")
  assert(type(entity.texture) == "userdata", "DrawEntity misses 'texture' or 'texture' is no Table" .. tostring(entity.texture))
  --- do not draw any mob outside the current window since it is
  --- just wasting resources
  if Utils.CheckCollision(
    entity.x,
    entity.y,
     entity.w or 32,
     entity.h or 32,
    GameData.settings.screen_x_view_factor,
    GameData.settings.screen_y_view_factor,
    GameData.settings.screen_w,
    GameData.settings.screen_h
  ) then
    --[[love.graphics.rectangle(
      "line",
      entity.x - GameData.settings.screen_x_view_factor,
      entity.y - GameData.settings.screen_y_view_factor,
      entity.w or 32 , entity.h or 32
    )]]
    love.graphics.draw(
      entity.texture,
      entity.x + ((entity.w or 32 )/ 2) - GameData.settings.screen_x_view_factor,
      entity.y + ((entity.h or 32 )/ 2) - GameData.settings.screen_y_view_factor,
      entity.rotation,
      1,
      1,
      (entity.w or 32 )/ 2,
      (entity.w or 32 )/ 2
    )

    -- todo make relative to the max health
    if entity.health ~= nil then
      love.graphics.setColor(1,1,1,1)
      love.graphics.line(
        entity.x - GameData.settings.screen_x_view_factor ,
        entity.y - 10 - GameData.settings.screen_y_view_factor,
        entity.x  + math.floor(entity.health) - GameData.settings.screen_x_view_factor,
        entity.y - 10 - GameData.settings.screen_y_view_factor
      )
    end
  end

end


return DrawProtocol