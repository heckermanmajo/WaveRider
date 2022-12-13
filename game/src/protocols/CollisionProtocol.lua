---Protocol-"Class" for the CollisionProtocolFunction
---@class CollisionProtocolEntity
---@field x number
---@field y number
---@field hard boolean

local current_cohort = 0

--- Simple Protocol for collision of entities
--- For now it needs to be applied every frame
--- Works by comparing each entity to each oter entity.
---
--- If they collide the overlapping is taken as force and
--- this force is applied itno the other direction of the collision.
--- So entities will push each other out of themselfes.
--- Except one is defined as "hard", then only the not hard
--- one is pushed out.
---
--- If both are defined as hard, they are not alloed to collide.
--- If they do, the firts in the list is pushed out.
---
---@param all_collision_entities CollisionProtocolEntity[]
function CollisionProtocol(all_collision_entities, delta_frame)
  -- todo We need to optimize this by calling it not each frame
  -- todo But then we need to change delta frame to delta_frame * how_less_often_we_call_it
  assert(type(all_collision_entities) == "table")
  local _all_collision_entities = all_collision_entities

  if #all_collision_entities > 200 then
    _all_collision_entities = {}
    local start = math.floor(current_cohort * #all_collision_entities / 60)
    local _end = math.floor(current_cohort * #all_collision_entities / 60 + #GameData.zombies / 60)
    for i = start, _end do
      table.insert(_all_collision_entities, GameData.zombies[i])
    end
    --print(start)
    --print(_end)
    --print(current_cohort)
    current_cohort = current_cohort+1
    if current_cohort > 60 then
      current_cohort = 0
    end
  end

  for key, entity in ipairs(_all_collision_entities) do
    entity.collision_force_x = 0
    entity.collision_force_y = 0
  end

  -- loop over all entities
  for key, entity in ipairs(_all_collision_entities) do

    -- check if the entity matches the protocol
    assert(type(entity.x) == "number", "CollisionEntity misses 'x' or 'x' is no Number")
    assert(type(entity.y) == "number", "CollisionEntity misses 'y' or 'y' is no Number")
    assert(type(entity.hard) == "boolean", "CollisionEntity misses 'hard' or 'hard' is no Bool")

    -- loop again over all entities, since everybody can collide with everybody else
    for other_key, other_entity in ipairs(all_collision_entities) do

      -- check that the other entity matches the protocol
      -- needed twice, since we use every entity right after
      -- the first check of the outer loop
      assert(type(other_entity.x) == "number", "CollisionEntity misses 'x' or 'x' is no Number")
      assert(type(other_entity.y) == "number", "CollisionEntity misses 'y' or 'y' is no Number")
      assert(type(other_entity.hard) == "boolean", "CollisionEntity misses 'hard' or 'hard' is no Bool")

      if other_entity.id ~= entity.id then
        -- do not check collision with myself
        if Utils.CheckCollision(
          entity.x,
          entity.y,
          entity.w,
          entity.h,
          other_entity.x,
          other_entity.y,
          other_entity.w,
          other_entity.h
        ) then
          -- get the depth of the collision at the x scale
          -- aka the number of overlapping pixels
          local correct_x = Utils.GetXCollisionForce(
            entity.x,
            32,
            other_entity.x,
            32
          )
          -- get the depth of the collision at the y scale
          -- aka the number of overlapping pixels
          local correct_y = Utils.GetYCollisionForce(
            entity.y,
            32,
            other_entity.y,
            32
          )

          -- check if the entity is colling at the right or left side
          -- with the other_entitiy, so we can apply the force on the right side
          if entity.x > other_entity.x then
            -- apply half the force at each entity
            -- except the entity i collide with is hard
            if other_entity.hard then
              entity.collision_force_x = entity.collision_force_x + correct_x
              --entity.x = entity.x + correct_x * delta_frame
            else
              entity.collision_force_x = entity.collision_force_x + correct_x / 2
              other_entity.collision_force_x = entity.collision_force_x - correct_x / 2
              --entity.x = entity.x + correct_x / 2 * delta_frame
              --other_entity.x = other_entity.x - correct_x / 2 * delta_frame
            end
          else
            -- apply half the force at each entity
            -- except the entity i collide with is hard
            if other_entity.hard then
              entity.collision_force_x = entity.collision_force_x - correct_x
              --entity.x = entity.x - correct_x * delta_frame
            else
              entity.collision_force_x = entity.collision_force_x - correct_x / 2
              other_entity.collision_force_x = entity.collision_force_x + correct_x / 2
              --entity.x = entity.x - correct_x / 2 * delta_frame
              --other_entity.x = other_entity.x + correct_x / 2 * delta_frame
            end
          end

          -- check if the entity is colliding at the top or the bottom
          -- with the other entity, so we can apply the force at the right side
          if entity.y > other_entity.y then
            -- apply half the force at each entity
            -- except the entity i collide with is hard
            if other_entity.hard then
              entity.collision_force_y = entity.collision_force_y + correct_y
              --entity.y = entity.y + correct_y * delta_frame
            else
              entity.collision_force_y = entity.collision_force_y + correct_y / 2
              other_entity.collision_force_y = entity.collision_force_y - correct_y / 2
              --entity.y = entity.y + correct_y / 2 * delta_frame
              --other_entity.y = other_entity.y - correct_y / 2 * delta_frame
            end
          else
            -- apply half the force at each entity
            -- except the entity i collide with is hard
            if other_entity.hard then
              entity.collision_force_y = entity.collision_force_y - correct_y
              --entity.y = entity.y - correct_y * delta_frame
            else
              entity.collision_force_y = entity.collision_force_y - correct_y / 2
              other_entity.collision_force_y = entity.collision_force_y + correct_y / 2
              --entity.y = entity.y - correct_y / 2 * delta_frame
              --other_entity.y = other_entity.y + correct_y / 2 * delta_frame
            end
          end

        end -- collision happens
      end -- entity and other_entity are not the same
    end  -- for loop
  end -- for loop
end -- function



return CollisionProtocol