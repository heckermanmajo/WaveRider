--local Window = require("uilib/Window")
local Game = {

  screen_width = 1900,
  screen_height = 1078,
  world_width = 3200,
  world_height = 3200,
  screen_title = "Zombie Runner",
  screen_x_factor = 1,
  screen_y_factor = 1,
  scroll_factor = 1,

  screen_vel_x = 0,
  screen_vel_y = 0,
  last_x = 0,
  last_y = 0,
  velx = 0, -- for scrolling

  mouseOverUI = false,
  windowDragAround = false,

  selected_tile = nil,
}

function Game.update(dt)

  Game.applyMouseScroll(dt)
  Game.dragTheWorldAround(dt)


end

function Game.getCurrentScreenFactorX()

  return Game.screen_x_factor * Game.scroll_factor + Game.screen_width / 2 * (1 - Game.scroll_factor)

end

function Game.getCurrentScreenFactorY()

  return Game.screen_y_factor * Game.scroll_factor + Game.screen_height / 2 * (1 - Game.scroll_factor)

end

function Game.isOutsideWorld(x, y)
  return x < 0 or y < 0 or x > Game.world_width or y > Game.world_height
end

function Game.applyMouseScroll(dt)

  Game.scroll_factor = Game.scroll_factor + Game.velx * 0.1 * dt
  local apply = false
  if Game.velx ~= 0 then
    apply = true
  end

  if Game.scroll_factor < 0.8 then
    Game.scroll_factor = 0.8
    apply = false
  end
  if Game.scroll_factor > 3 then
    Game.scroll_factor = 3
    apply = false
  end

  --- drag the Game.screen_factors towards the mouse position
  --[[if apply then
    local x, y = love.mouse.getPosition()
    local dx = x - Game.screen_width / 2
    local dy = y - Game.screen_height / 2
    local d = math.sqrt(dx * dx + dy * dy)
    if d > 0 then
      local current_scroll_speed = (dt)
      Game.screen_x_factor = Game.screen_x_factor - dx * current_scroll_speed-- * Game.screen_width
      Game.screen_y_factor = Game.screen_y_factor - dy * current_scroll_speed --* Game.screen_height

    end
  end
  ]]

  -- Gradually reduce the velocity to create smooth scrolling effect.
  Game.velx = Game.velx - Game.velx * math.min(dt * 10, 1)

  if Game.velx < 0.01 and Game.velx > -0.01 then
    Game.velx = 0
  end


end

function Game.dragTheWorldAround(dt)
  if Game.windowDragAround then
    return
  end

  local x, y = love.mouse.getPosition()

  if love.mouse.isDown(1) then

    if Game.last_x == nil then
      Game.last_x = x
    end
    if Game.last_y == nil then
      Game.last_y = y
    end

    Game.screen_vel_x = x - Game.last_x
    Game.screen_vel_y = y - Game.last_y

    Game.last_x = x
    Game.last_y = y

  else
    Game.last_x = nil
    Game.last_y = nil
  end

  Game.screen_x_factor = Game.screen_x_factor - Game.screen_vel_x
  Game.screen_y_factor = Game.screen_y_factor - Game.screen_vel_y

  Game.screen_vel_x = Game.screen_vel_x - Game.screen_vel_x * math.min(dt * 1, 1)
  Game.screen_vel_y = Game.screen_vel_y - Game.screen_vel_y * math.min(dt * 1, 1)

  if Game.screen_vel_x < 0.01 and Game.screen_vel_x > -0.01 then
    Game.screen_vel_x = 0
  end
  if Game.screen_vel_y < 0.01 and Game.screen_vel_y > -0.01 then
    Game.screen_vel_y = 0
  end


end

function love.wheelmoved(dx, dy)
  Game.velx = Game.velx + dy * 20
  ---vely = vely + dy * 20
  print("dx: " .. dx .. " dy: " .. dy)
end

return Game