
---@class FirstAid
---@field x number
local FirstAid = {

}

---@param health_amount number how much points are added back to the player health
function FirstAid.new(x,y,health_amount)
  local this = {}
  this.x = x
  this.y = y
  this.w = 32
  this.h = 32
  this.rotation = 0
  this.texture = GameData.textures.object_textures.first_aid
  this.health_amount = health_amount
  setmetatable(this, FirstAid)
  table.insert(GameData.first_aid, this)
  return this
end

function FirstAid.spawn()
  local health_amount = math.random(10, 40)
  FirstAid.new(
    GameData.settings.world_w * math.random(),
    GameData.settings.world_h * math.random(),
    health_amount
  )
  WaveGame.delay(FirstAid.spawn, math.random(30,60))
end

function FirstAid.pickup(delta_frame)

  ---@param first_aid FirstAid
  for key,first_aid in ipairs(GameData.first_aid) do
    if Utils.CheckCollision(
      first_aid.x,
      first_aid.y,
      first_aid.w,
      first_aid.w,
      GameData.player.x,
      GameData.player.y,
      32,
      32
    ) then
      GameData.player.health = GameData.player.health + first_aid.health_amount
      table.remove(GameData.first_aid, key)
      GameData.sounds.player.pickup_healing:stop()
      GameData.sounds.player.pickup_healing:play()
    end
  end
end

function FirstAid.draw_all()
  ---@param first_aid FirstAid
  for key,first_aid in ipairs(GameData.first_aid) do
    DrawProtocol(first_aid)
  end
end

return FirstAid