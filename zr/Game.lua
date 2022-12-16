---@class Game The game class contains all global data that is needed to
---       so the game can run properly. The Games, means the currently
---       running game. The game class is a singleton.
---       All values with _ are private!
---@field screen_width number The width of the screen in pixels.
---@field screen_height number The height of the screen in pixels.
---@field world_width number The width of the world in pixels.
---@field world_height number The height of the world in pixels.
---@field screen_title string The title of the screen.
---@field scroll_x_factor number The factor to scroll the screen in x direction.
---@field scroll_y_factor number The factor to scroll the screen in y direction.
---@field scroll_factor number The factor to scroll the screen.
---@field mouseOverUI boolean True if the mouse is over an UI element (not apply a possible click on the World elements, like units or tiles)
---@field windowDragAround boolean True if the window is dragged around (not drag around the world-view). This is set by the Window class.
---@field selected_tile Tile|nil The currently selected tile. Can be nil.
---@field private _screen_vel_x number The velocity of the screen in x direction.
---@field private _screen_vel_y number The velocity of the screen in y direction.
---@field private _last_x number The last x position of the mouse.
---@field private _last_y number The last y position of the mouse.
---@field private _velocity_zoom boolean True if the screen is scrolled with the mouse wheel.
local Game = {

  screen_width = 1900,
  screen_height = 1078,
  world_width = 3200,
  world_height = 3200,
  screen_title = "Zombie Runner",
  screen_x_factor = 1,
  screen_y_factor = 1,
  scroll_factor = 1,
  mouseOverUI = false,
  windowDragAround = false,
  selected_tile = nil,

  _screen_vel_x = 0,
  _screen_vel_y = 0,
  _last_x = 0,
  _last_y = 0,
  _velocity_zoom = 0, -- for scrolling


}

--- The update function of the game class.
--- This function is called every frame.
--- @param dt number The delta time since the last frame.
--- @return nil
--- @see love.update
function Game.update(dt)
  local Game = Game -- local variable for faster access

  Game._applyMouseZoom(dt)
  Game._dragTheWorldAround(dt)

end


--- This function returns the current screen factor for the y axis
--- Screen factor is the number of pixels the screen is moved from the origin
--- to match the camera movement of the user.
--- In this function the scroll_factor (zoom in, zoom out) is taken into account
--- @return number
--- @see Game.getCurrentScreenFactorX
function Game.getCurrentScreenFactorY()
  local Game = Game -- local variable for faster access
  return (
    Game.screen_y_factor * Game.scroll_factor
      +
      Game.screen_height / 2 * (1 - Game.scroll_factor)
  )
end

--- This function returns the current screen factor for the x axis
--- Screen factor is the number of pixels the screen is moved from the origin
--- to match the camera movement of the user.
--- In this function the scroll_factor (zoom in, zoom out) is taken into account
--- @return number
--- @see Game.getCurrentScreenFactorY
function Game.getCurrentScreenFactorX()
  local Game = Game -- local variable for faster access
  return (
    Game.screen_x_factor * Game.scroll_factor
      +
      Game.screen_width / 2 * (1 - Game.scroll_factor)
  )

end

--- Returns false if the given x and y are outside the world.
--- @param x number x value in absolute coordinates
--- @param y number y value in absolute coordinates
--- @return boolean
function Game.isOutsideWorld(x, y)
  assert(x, "x is nil")
  assert(y, "y is nil")
  assert(type(x) == "number", "x is not a number")
  assert(type(y) == "number", "y is not a number")

  local Game = Game -- local variable for faster access

  return x < 0 or y < 0 or x > Game.world_width or y > Game.world_height
end

--- Applies the mouse zoom on the screen.
--- @param dt number delta time
--- @return nil
--- @private
--- called here: Game.update
--- @see Game.update
function Game._applyMouseZoom(dt)
  local Game = Game -- local variable for faster access
  --@todo: make the zoom factor configurable
  local zoom_factor = 0.1 -- how fast the zoom is applied
  --@todo: make the max and min zoom configurable
  local zoom_min = 0.8 -- min -> zoom out
  local zoom_max = 3 -- max -> zoom in

  local zoom_is_applied = false -- currently unused
  -- the idea was to center the scrolling towards the middle
  -- of the screen, but this is not working properly yet
  -- @todo: fix the centering of the zoom

  Game.scroll_factor = Game.scroll_factor + Game._velocity_zoom * zoom_factor * dt
  if Game._velocity_zoom ~= 0 then
    zoom_is_applied = true
  end

  if Game.scroll_factor < zoom_min then
    Game.scroll_factor = zoom_min
    zoom_is_applied = false
  end
  if Game.scroll_factor > zoom_max then
    Game.scroll_factor = zoom_max
    zoom_is_applied = false
  end

  -- Gradually reduce the velocity to create smooth zooming effect.
  Game._velocity_zoom = (
    Game._velocity_zoom
      -
      Game._velocity_zoom * math.min(dt * 10, 1)
  )

  if Game._velocity_zoom < 0.01 and Game._velocity_zoom > -0.01 then
    Game._velocity_zoom = 0
  end


end

--- This function drags the world around if the middle mouse button is pressed.
--- @param dt number delta time
--- @return nil
function Game._dragTheWorldAround(dt)
  local Game = Game -- local variable for faster access
  if Game.windowDragAround then
    return
  end

  local x, y = love.mouse.getPosition()

  -- drag the world around on the middle mouse button
  if love.mouse.isDown(3) then

    if Game._last_x == nil then
      Game._last_x = x
    end
    if Game._last_y == nil then
      Game._last_y = y
    end

    Game._screen_vel_x = x - Game._last_x
    Game._screen_vel_y = y - Game._last_y

    Game._last_x = x
    Game._last_y = y

  else
    Game._last_x = nil
    Game._last_y = nil
  end

  -- change the screen factor
  Game.screen_x_factor = Game.screen_x_factor - Game._screen_vel_x
  Game.screen_y_factor = Game.screen_y_factor - Game._screen_vel_y

  -- Gradually reduce the velocity to create smooth dragging effect.
  Game._screen_vel_x = Game._screen_vel_x - Game._screen_vel_x * math.min(dt * 1, 1)
  Game._screen_vel_y = Game._screen_vel_y - Game._screen_vel_y * math.min(dt * 1, 1)

  -- since we use smooth dragging, we need to round the values
  if Game._screen_vel_x < 0.01 and Game._screen_vel_x > -0.01 then
    Game._screen_vel_x = 0
  end

  -- since we use smooth dragging, we need to round the values
  if Game._screen_vel_y < 0.01 and Game._screen_vel_y > -0.01 then
    Game._screen_vel_y = 0
  end

end

--- This function is called in the love.wheelmoved callback
--- @param dx number this is not used
--- @param dy number this is the scroll direction
--- @return nil
--- @see love.wheelmoved
--- @see Game.applyMouseScroll
function Game.handleWheelMoved(dx, dy)
  local Game = Game
  Game._velocity_zoom = Game._velocity_zoom + dy * 20
end

-- return the Game class from the module
return Game