-- todo: make also not-temporal ones -> here_since = -1


---@class NonInteractionObject Tiles are simple images drawn on the s
local NonInteractionObject={}

function NonInteractionObject.new(
  x,
  y,
  image,
  rotation,
  duration,
  floating,
  w,
  h
)
  local this={}
  this.x=x
  this.y=y
  this.w = w or 32
  this.h = h or 32
  this.texture=image
  this.here_since= 0
  this.rotation=rotation
  this.duration = duration or 10
  this.float_direction = 0
  this.floating = floating or false
  setmetatable(
    this,
    NonInteractionObject
  )
  table.insert(
    GameData.non_interaction_objects,
    this
  )
  return this
end

function NonInteractionObject.progress(delta_frame)
  for key,nio in ipairs(GameData.non_interaction_objects) do
    nio.here_since=nio.here_since + delta_frame
    if nio.here_since > nio.duration then
      table.remove(
        GameData.non_interaction_objects,
        key
      )
    end
  end
end

function NonInteractionObject.draw_all()
  for key,nio in ipairs(GameData.non_interaction_objects) do
    DrawProtocol(nio)
  end
end

return NonInteractionObject