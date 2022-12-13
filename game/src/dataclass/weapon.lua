--[[
  Different weapon types:
  The Detail differences are set by the values
  -> Fluid: Flamethrower, Acid, aso.
  -> Throw: Granats
  -> Place: Mines
  -> shotgun: Multiple shots in different direction
  -> semi_automatic: pistol, sniper
  -> automatic: mg, mps
]]
--- @class Weapon The weapon class
--- @field
local Weapon = {
  weapons = {}
}

function Weapon:new()
  -- @todo needs type   -> determines how it fires
  -- @todo needs ammo-type
  -- @todo needs display png
end

return Weapon
