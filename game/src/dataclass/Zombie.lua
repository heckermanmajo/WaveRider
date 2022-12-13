--- @class Zombie
--- @field x = x
---  @field y = y
---  @field rotation = 0
---  @field speed = speed
---  @field state = "sleeping"  -- or hunting
---  @field damage = 30
---  @field alive = true
---  @field texture = texture or GameData.textures.zombie_textures.basic
---  @field die_texture = die_texture or GameData.textures.zombie_textures.dead
---  @field hard = false
local Zombie = {}

--- @deprecated
--- use ZombieSpawnController.spawn() instead
function Zombie.spawn()
  --ZombieSpawnController.spawn()
end

function Zombie.new(x, y, speed, texture, die_texture, w, h, health, spawn_on_dead)
  local o = {}
  o.x = x
  o.y = y
  o.id = Utils.uid()
  o.rotation = 0
  o.speed = speed
  o.state = "sleeping"  -- or hunting
  o.damage = 30
  o.alive = true
  o.texture = texture or GameData.textures.zombie_textures.basic
  o.die_texture = die_texture or GameData.textures.zombie_textures.dead
  o.hard = false
  o.health = health or 50
  o.w = w or 32
  o.h = h or 32
  o.spawn_on_dead = spawn_on_dead or false
  o.collision_force_x = 0
  o.collision_force_y = 0
  o.wander_off = false
  o.wander_target_x = math.random(
    100, GameData.settings.world_w - 100
  )
  o.wander_target_y = math.random(
    100, GameData.settings.world_h - 100
  )
  o.target = nil  --- if the zombie targets not thy player but a unit
  Zombie.__index = Zombie
  setmetatable(o, Zombie)
  return o
end

--- @deprecated
--- Use  ZombieWaveController.wave() instead
function Zombie.make_wave()

  ZombieWaveController.wave()

end

local update_counter = 0

function Zombie.move_and_fight(delta_frame)

  update_counter = update_counter + 1
  if update_counter % 1 == 0 then
    local collision_units = {}
    for k, v in pairs(GameData.zombies) do
      collision_units[k] = v
    end
    table.insert(collision_units, Player)
    CollisionProtocol(collision_units, delta_frame * 2)
    update_counter = 0
  end

  for key, z in ipairs(GameData.zombies) do
    local change_x = z.collision_force_x * delta_frame --* z.speed
    local change_y = z.collision_force_y * delta_frame --* z.speed
    z.x = z.x + change_x
    z.y = z.y + change_y
    z.collision_force_x = z.collision_force_x - change_x
    z.collision_force_y = z.collision_force_y - change_y
    --z.collision_force_y = z.collision_force_y - 1 * delta_frame
    --z.collision_force_x = z.collision_force_x - 2
  end

  for key, z in ipairs(GameData.zombies) do
    --- zombie targtet a trooper
    if z.target ~= nil then
      --- follow trooper
      if z.target.health <= 0 then
        z.target = nil   -- now we follow the player again
      end
    end
    -- Zombie state change if the user comes close
    if z.state == "sleeping" then
      if (
        (GameData.player.x - z.x + 16) ^ 2
          + (GameData.player.y - z.y + 16) ^ 2 <
          200 ^ 2
      ) then
        z.state = "hunting"
        GameData.sounds.zombie.aggro:stop()
        GameData.sounds.zombie.aggro:play()
      end
    end

    -- move to the player if the zombie is in hunting mode
    if z.state == "hunting" then
      local target_x = GameData.player.x
      local target_y = GameData.player.y
      local _target = GameData.player

      if z.target ~= nil then
        target_x = z.target.x
        target_y = z.target.y
        _target = z.target
      end

      if z.wander_off then
        target_x = z.wander_target_x
        target_y = z.wander_target_y
        if
        Utils.CheckCollision(
          z.x - 30,
          z.y - 30,
          60,
          60,
          z.wander_target_x - 20,
          z.wander_target_y - 20, 40, 40
        )
        then
          z.wander_off = false -- attack
        end
      end

      if update_counter % 2 == 0 then
        -- create damage
        if Utils.CheckCollision(
          z.x,
          z.y,
          z.w + 16,
          z.h + 16,
          _target.x,
          _target.y,
          _target.w,
          _target.h
        ) then
          GameData.sounds.player.hurt:play()
          _target.health = _target.health - z.damage * delta_frame
        end
      end

      local z_direction = (
        math.atan2(
          (target_y + math.random() * 50 - z.y),
          (target_x + math.random() * 50 - z.x)
        )
      )

      z.x = z.x + math.cos(z_direction) * z.speed * delta_frame
      z.y = z.y + math.sin(z_direction) * z.speed * delta_frame

      -- rotate the zombie to the player
      z.rotation = Utils.get_rotation(
        z.x,
        z.y,
        target_x,
        target_y
      )


    end
  end
end

function Zombie:die()
  self.alive = false
  --- unregister the zombie here
  if self.spawn_on_dead then
    Money:new(
      self.x + math.random(10, 20),
      self.y + math.random(10, 20),
      math.random(1, 3)
    )
  end
end

function Zombie.draw_all()
  for key, zombie in ipairs(GameData.zombies) do
    DrawProtocol(zombie)
  end
end

return Zombie