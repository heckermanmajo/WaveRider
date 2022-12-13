
--- Dataclass for flying projectiles
local Projectile = {}

function Projectile:new()
  local this = {}


  self.__index = self
  setmetatable(this, self)
  return this
end

return Projectile