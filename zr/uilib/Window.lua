local Utils = require("utils")
local TextElement = require("uilib/TextElement")
local Game = require("Game")

local Window = {
  instances = {},
  windowsAsList = {},
  counter = 1,
  last_x = nil,
  last_y = nil,
  one_is_dragged = false,
}
Window.__index = Window

function Window.new(
  x,
  y,
  width,
  height,
  title
)
  local self = setmetatable({}, Window)

  Window.instances[Window.counter] = self
  table.insert(Window.windowsAsList, self)

  self.id = Window.counter
  Window.counter = Window.counter + 1

  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.title = title
  self.last_mouse_x = nil
  self.last_mouse_y = nil
  self.drag_activated = false
  self.elements = {}
  self.onClose = nil
  self.collapse = false

  self.titleBarHeight = 40
  self.titleBarColor = { 0.2, 0.2, 0.2, 1 }

  self.backgroundColor = { 0.1, 0.1, 0.1, 1 }

  return self
end

function Window:draw()
  -- draw a react
  -- draw a title

  if not self.collapse then
    -- draw the background
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle(
      "fill",
      self.x,
      self.y,
      self.width,
      self.height
    )
  end

  -- draw the title bar
  love.graphics.setColor(self.titleBarColor)
  love.graphics.rectangle(
    "fill",
    self.x,
    self.y,
    self.width,
    self.titleBarHeight
  )

  -- draw the title
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(
    self.title,
    self.x + 5,
    self.y + 5
  )

  -- todo: make real button from this
  -- draw a close button at the right side of the title bar
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(
    "X",
    self.x + self.width - 15,
    self.y + 5
  )

  if self.collapse then
    -- draw the uncollapse button


    return
  end

  -- draw the elements
  local height = self.titleBarHeight + 5
  for i = 1, #self.elements do
    self.elements[i]:draw(self.x, self.y + height, self.width)
    height = height + self.elements[i]:getHeight(self.width)
  end

end

function Window:update()
  -- todo: make real button from this
  -- if click on close button then close the window
  if love.mouse.isDown(1) then
    local x, y = love.mouse.getPosition()
    if x > self.x + self.width - 15 and x < self.x + self.width - 5 then
      if y > self.y + 5 and y < self.y + 15 then
        print("Window.update: close window")
        self:close()
      end
    end
    if self:hover() then
      Game.mouseOverUI = true
    end
  end
end

function Window:hover()
  local x, y = love.mouse.getPosition()
  if x > self.x and x < self.x + self.width then
    if y > self.y and y < self.y + self.height then
      return true
    end
  end
  return false
end

function Window:close()
  if self.onClose then
    self.onClose()
  end
  Window.instances[self.id] = nil
  local index = Utils.getIndexOf(Window.windowsAsList, self)
  table.remove(Window.windowsAsList, index)
end

function Window.updateAll()
  local drag = false
  for key, window in ipairs(Window.windowsAsList) do
    --print(key)
    if window ~= nil then
      window:update()
      if window:drag() then
        drag = true
      end
    else
      print("Window.updateAll: window is nil")
    end
    --window:update()
  end
  Game.windowDragAround = drag
end

function Window.drawAll()
  for key, window in ipairs(Window.windowsAsList) do
    window:draw()
  end
end

function Window:drag()
  -- if click on title bar then drag the window
  if love.mouse.isDown(1) then
    local x, y = love.mouse.getPosition()
    if x > self.x and x < self.x + self.width then
      if y > self.y and y < self.y + self.titleBarHeight then
        if self.drag_activated == false and not Window.one_is_dragged then
          self.last_mouse_x = x
          self.last_mouse_y = y
          self.drag_activated = true
          Window.one_is_dragged = true
        end
      end
    end

    if self.drag_activated then
      local dx = x - self.last_mouse_x
      local dy = y - self.last_mouse_y
      self.x = self.x + dx
      self.y = self.y + dy
      self.last_mouse_x = x
      self.last_mouse_y = y
      return true
    end
  else
    self.last_mouse_x = nil
    self.last_mouse_y = nil
    self.drag_activated = false
    Window.one_is_dragged = false
  end
  return false
end

function Window:addTextElement(text)
  -- add a text to the window
  local textElement = TextElement.new(text)
  table.insert(self.elements, textElement)
end

return Window