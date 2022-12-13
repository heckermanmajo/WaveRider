local TextElement = {}
TextElement.__index = TextElement

function TextElement.new(text, color)
  local self = setmetatable({}, TextElement)
  self.text = text
  if color == nil then
    self.color = { 1, 1, 1, 1 }
  else
    self.color = color
  end
  return self
end

function TextElement:getWidth()
  return love.graphics.getFont():getWidth(self.text)
end

function TextElement:breakToLongAtSpace(maxWidth)
  local words = {}
  local currentWord = ""
  for i = 1, #self.text do
    local char = self.text:sub(i, i)
    if char == " " then
      table.insert(words, currentWord)
      currentWord = ""
    else
      currentWord = currentWord .. char
    end
  end
  table.insert(words, currentWord)
  local lines = {}
  local currentLine = ""
  for i = 1, #words do
    local word = words[i]
    local width = love.graphics.getFont():getWidth(currentLine .. word)
    if width > maxWidth then
      table.insert(lines, currentLine)
      currentLine = " " .. word
    else
      currentLine = currentLine .." ".. word
    end
  end
  table.insert(lines, currentLine)
  return lines
end

function TextElement:draw(x,y,maxWidth)
  if maxWidth == nil then
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, x, y)
  else
    -- todo: this might be slow
    local lines = self:breakToLongAtSpace(maxWidth)
    for i = 1, #lines do
      love.graphics.setColor(self.color)
      love.graphics.print(lines[i], x, y + (i - 1) * 20)
    end
  end
end

function TextElement:getHeight(maxWidth)
  if maxWidth == nil then
    return love.graphics.getFont():getHeight()
  else
    local lines = self:breakToLongAtSpace(maxWidth)
    return #lines * love.graphics.getFont():getHeight()
  end
end




return TextElement
