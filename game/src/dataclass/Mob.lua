--[[

  Mob Thoughts:
  Every unit is a mob.

  If you create a mob class, you can make everything default and only
  set it for the individual mob, if the individual mob diverts from the
  norm.

  Tasks you add to the mob later.

  All mobs collide with all othe moby so we get realistic
  combat and big long battles, if the units are a lot.

]]

--- @class Mob
--- @field __mobtypename__ string the name of the mob type
--- @field __mobtype__ any The name of the type. The mob is registered in the GameData by this name.
--- @field id number The index of this mob in the mob array.
--- @field faction Faction A refrence to the faction this unit belongs to
--- @field rotation
--- @field x
--- @field y
--- @field w
--- @field h
--- @field texture
--- @field stand_texture
--- @field die_texture
--- @field speed number
--- @field weapon Weapon The Weapon the Mob uses.
--- @field health number
--- @field max_health number
--- @field armor_value number The armor number can prevent the unit from a lot of damage. It is a percentage, reduction of damage.
--- @field look_range
--- @field hold_postion boolean
--- @field defend boolean
--- @field attack boolean
--- @field formation Formation The formation this mob is part of.
--- @field selected boolean Is this unit selected by the player.
--- @field height number How high stands this unit. (Mountain, Building?)
--- @field tile Tile On what tile stands this unit
--- @field move_target Tile
--- @field path Tile[]
--- @field ui_name string
--- @field ui_description
--- @field collision_force_x
--- @field collision_force_y
--- @field can_burn
--- @field attack_mob_target
--- @field attack_building_target
--- @field action_world_object_target
--- @field current_path_step number

local Mob = {
  instances = {}
}

--[[

SpecificUnitType:new()
  local this = Mob:new()
  setmetatable(SpecificUnitType, this)
  this.__mobtype__ = SpecificUnitType
end

]]


function Mob:new(x, y)
  local this = {}
  this.__mobtypename__ = "Mob" --- @field __mobtypename__ string the name of the mob type
  this.__mobtype__ = self --- @field __mobtype__ any The name of the type. The mob is registered in the GameData by this name.
  this.id = Utils.uid() --- @field id number The index of this mob in the mob array.
  --this.faction = Faction.getPlayerFaction() --- @field faction Faction A refrence to the faction this unit belongs to
  this.rotation = 0 --- @field rotation
  this.x = x --- @field x
  this.y = y --- @field y
  this.w = 32--- @field w
  this.h = 32--- @field h
  this.texture = GameData.textures.player_textures.basic --- @field texture
  this.stand_texture = this.texture--- @field stand_texture
  this.die_texture = this.texture--- @field die_texture
  this.speed = 100 --- @field speed number
  this.weapon = nil--- @field weapon Weapon The Weapon the Mob uses.
  this.health = 100--- @field health number
  this.max_health = 100--- @field max_health number
  this.armor_value = 0--- @field armor_value number The armor number can prevent the unit from a lot of damage. It is a percentage, reduction of damage.
  this.look_range = 100--- @field look_range
  this.hold_postion = false--- @field hold_postion boolean
  this.defend = false--- @field defend boolean
  this.attack = true--- @field attack boolean
  this.formation = nil--- @field formation Formation The formation this mob is part of.
  this.selected = false--- @field selected boolean Is this unit selected by the player.
  this.height = 32 --- @field height number How high stands this unit. (Mountain, Building?)
  this.tile = Tile.get(this.x, this.y) -- @field tile Tile On what tile stands this unit
  this.move_target = nil --- @field move_target Tile
  this.path = {} --- @field path Tile[]
  this.ui_name = "DefaultMob" --- @field ui_name string
  this.ui_description = "Some Mob" --- @field ui_description
  this.collision_force_x = 0 --- @field collision_force_x
  this.collision_force_y = 0 --- @field collision_force_y
  this.can_burn = true--- @field can_burn
  this.attack_mob_target = nil--- @field attack_mob_target
  this.attack_building_target = nil--- @field attack_building_target
  this.action_world_object_target = nil--- @field action_world_object_target
  this.current_path_step = 0--- @field current_path_step number

  for i = 1, 10000 do
    if self.instances[i] == nil then
      self.instances[i] = this
      break
    end
  end

  return this

end

--- Check if the given instance has all needed mob fields
function Mob.check_mob(instance)
  assert(instance.x and type(instance.x == "number"))
  -- add more 
end

--- Handle the deletion of a mob
--- Remove from tile, from GameState and call its own die function
--- Draw the die sprite
--- Draw some Blood
function Mob.die()

end

--- Draw the mob and also draw the rectangle.
--- @param mob Mob
function Mob.draw_mob(mob)

  love.graphics.draw(
    mob.texture,
    mob.x - GameData.settings.screen_x_view_factor,
    mob.y - GameData.settings.screen_y_view_factor,
    mob.rotation
  )

  if mob.selected then
    love.graphics.rectangle(
      "line",
      mob.x - GameData.settings.screen_x_view_factor,
      mob.y - GameData.settings.screen_y_view_factor,
      mob.w,
      mob.h
    )
  end

  -- display a rectangle around the mob if the mob is hidden behind a wall
  -- or building
  if Tile.get(mob.x + 32, mob.y + 32).height > mob.tile.height then
    love.graphics.rectangle(
      "line",
      mob.x - GameData.settings.screen_x_view_factor,
      mob.y - GameData.settings.screen_y_view_factor,
      mob.w,
      mob.h
    )
  end

  for i, t in ipairs(mob.path) do
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle(
      "fill",
      t.x - GameData.settings.screen_x_view_factor,
      t.y - GameData.settings.screen_y_view_factor,
      34,
      34
    )
    love.graphics.setColor(1, 1, 1, 1)
  end
end

--- If a mob collides with an enemy: fight
--- If it is a friendly unit: Go to the next free tile
--- If the tile i am will be on is taken: go in a random direction until you meet a fre tile
--- @param mob Mob
function Mob.unit_collision(mob)
  -- todo: introduce local variables to not access Tile and call get every time
  if Tile.get(mob.x, mob.y).mob ~= nil then
    if Tile.get(mob.x, mob.y).mob.id ~= mob.id then
      local x_direction
      local y_direction
      repeat
        x_direction = math.random(-1, 1)
        y_direction = math.random(-1, 1)
      until (x_direction ~= 0 or y_direction ~= 0)
      for i = 1, 20 do
        if Tile.get(
          mob.x + 32 * i * x_direction,
          mob.y + 32 * i * y_direction
        )      .mob == nil then
          Tile.get(
            mob.x + 32 * i * x_direction,
            mob.y + 32 * i * y_direction
          )   .mob = mob
          mob.tile = Tile.get(
            mob.x + 32 * i * x_direction,
            mob.y + 32 * i * y_direction
          )
          break
        end
      end
    end
  else
    Tile.get(mob.x, mob.y).mob = mob
    mob.tile = Tile.get(mob.x, mob.y)
  end
end

--- Look for the nearest enemy in the range
--- Wee need to have the faction information for this
function Mob.select_nearest_enemy()
  -- todo
end

--- This function updates the move target for the mob
--- @param mob Mob
--- @param new_move_target Tile
function Mob.update_move_target(mob, new_move_target)
  if new_move_target.passable == false then
    return
  end
  mob.move_target = new_move_target
  if mob.tile.x ~= mob.move_target.x or mob.tile.y ~= mob.move_target.x then
    mob.path = Tile.get_path(
      mob.tile.x,
      mob.tile.y,
      mob.move_target.x,
      mob.move_target.y,
      mob
    )
    mob.current_path_step = 1
  end
end

--- This function sets a target for a mob.
--- The mob will try to reach the target position.
--- @param mob Mob
function Mob.move(mob, delta_frame)
  if #mob.path == 0 then
    return
  end
  local next_step = mob.path[mob.current_path_step]
  if next_step == nil then
    mob.path = {}
    mob.move_target = nil
    -- i am at the goal
    return
  end
  if next_step.mob == nil then
    -- if the next on the road is blocked, stay here
    -- move on
    local speed = mob.speed
    if next_step.x ~= mob.x and next_step.y ~= mob.y then
      speed = speed * 0.5
    end
    if next_step.x < mob.x then
      mob.x = math.floor(mob.x - mob.speed * delta_frame)
    end
    if next_step.x > mob.x then
      mob.x = math.floor(mob.x + mob.speed * delta_frame)
    end
    if next_step.y < mob.y then
      mob.y = math.floor(mob.y - mob.speed * delta_frame)
    end
    if next_step.y > mob.y then
      mob.y = math.floor(mob.y + mob.speed * delta_frame)
    end
    if Utils.collision({ x = mob.x, y = mob.y, w = 1, h = 1 }, next_step) then
      mob.tile = next_step
      mob.current_path_step = mob.current_path_step + 1
    end
  end
  -- todo if the move target is the next tile and the next tile is blocked the new target is me
end

--- Attack other mobs or buildings
function Mob.receive_attack_action()

end

--- receive an interact order
--- Build a building, harvest an object
function Mob.receive_interact_action()

end

return Mob