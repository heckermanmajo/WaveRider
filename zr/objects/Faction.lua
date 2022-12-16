--- @class Faction

local Faction = {
  __cls = Faction,
  __name = "Faction",
  instances = {},
  instancesAsList = {},
  images = {},
}
Faction.__index = Faction

function Faction.new(name)
  assert(type(name) == "string", "name must be a string")
  local self = setmetatable({}, Faction)
  table.insert(Faction.instances, self)
  self.id = #Faction.instances
  self.name = name
  self.color = { 1, 1, 1, 1 }
  self.resources = {}
  self.buildings = {}
  self.units = {}
end


return Faction