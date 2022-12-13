---@version waverider 1.0

--- @class Ammo Ammo you can pick up
--- @field x number The x coordinate - (width/2)
--- @field y number The y coordinate - (width/2)
--- @field width number The width of the ammunition (static 32px for now)
--- @field amount number The amount of ammunition to pick up
--- @todo Add the weapon type in the future
local Ammo = {}

function Ammo.new(
  start_x,
  start_y,
  type
)
  local this = {}
  this.x = start_x
  this.y = start_y
  this.w = 32
  this.h = 32
  this.type = type or "rifle"
  this.rotation = 0  --- the ammo has no rotation
  local max = GameData.zombie_config.start_wave_amount
  if this.type == "rifle" then
    this.amount = math.floor(math.random(10, 50))
    this.texture = GameData.textures.object_textures.ammo
  elseif this.type == "granate" then
    this.amount = math.floor(math.random(2, 10))
    this.texture = GameData.textures.object_textures.granates_box
  elseif this.type == "shotgun_ammo" then
    this.amount = math.floor(math.random(3, 30))
    this.texture = GameData.textures.object_textures.shotgun_ammo
  end
  setmetatable(this, Ammo)
  return this
end

--- Spawns ammo and calls itself in an steady interval
--- @return nil
function Ammo.spawn_ammo_interval()
  local ammo = Ammo.new(
    GameData.settings.world_w * math.random(),
    GameData.settings.world_h * math.random(),
    "rifle"
  )
  table.insert(GameData.ammo, ammo)

    local ammo2 = Ammo.new(
    GameData.settings.world_w * math.random(),
    GameData.settings.world_h * math.random(),
    "shotgun_ammo"
  )
  table.insert(GameData.ammo, ammo2)

  WaveGame.delay(Ammo.spawn_ammo_interval, math.random(10, 30))
end

--- Spawns ammo and calls itself in an steady interval
--- @return nil
function Ammo.spawn_granate_interval()
  local ammo = Ammo.new(
    GameData.settings.world_w * math.random(),
    GameData.settings.world_h * math.random(),
    "granate"
  )
  table.insert(GameData.ammo, ammo)
  WaveGame.delay(Ammo.spawn_granate_interval, math.random(10, 30))
end

function Ammo.draw_all()
  for key, ammo in ipairs(GameData.ammo) do
    DrawProtocol(ammo)
    love.graphics.print(
      tostring(ammo.amount),
      ammo.x +26 - GameData.settings.screen_x_view_factor,
      ammo.y + 26 - GameData.settings.screen_y_view_factor,
      0,
      1,
      1
    )

  end
end

function Ammo.pickup()
  for key, ammo in ipairs(GameData.ammo) do
    if Utils.CheckCollision(
      GameData.player.x,
      GameData.player.y,
      32,
      32,
      ammo.x,
      ammo.y,
      32,
      32
    ) then
      if ammo.type == "rifle" then
        GameData.player.weapon.bullets = GameData.player.weapon.bullets + ammo.amount
      elseif ammo.type == "granate" then
        GameData.player.weapon.granates = GameData.player.weapon.granates + ammo.amount
      elseif ammo.type == "shotgun_ammo" then
        GameData.player.weapon.shotgun_ammo = GameData.player.weapon.shotgun_ammo + ammo.amount
      end
      table.remove(
        GameData.ammo,
        key
      )
      GameData.sounds.player.pickup_ammo:stop()
      GameData.sounds.player.pickup_ammo:play()
    end
  end
end

return Ammo