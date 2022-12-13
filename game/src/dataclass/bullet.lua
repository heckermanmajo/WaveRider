local Bullet = {}

function Bullet.new(
  start_x,
  start_y,
  target_x,
  target_y,
  direction,
  speed,
  type
)

  if type == nil then
    type = "rifle"
  end

  local o = {}
  o.x = start_x
  o.y = start_y
  o.hard = false -- if hard, it can smash trough enemies

  if type == "rifle" then
    o.texture = GameData.textures.projectile_textures.bullet
  end

  if type == "granate" then
    o.texture = GameData.textures.projectile_textures.granate
  end

  local fly_direction = math.atan2((target_y - start_y),
                                   (target_x - start_x))
  o.x_acceleration = math.cos(fly_direction)
  --if target_x < start_x then o.x_acceleration = -1 * o.x_acceleration end
  o.y_acceleration = math.sin(fly_direction)
  --if target_y < start_y then o.y_acceleration = -1 * o.y_acceleration end
  o.direction = direction
  o.rotation = direction   --- fixme
  o.speed = speed
  o.w = 8
  o.h = 8
  setmetatable(o,
               Bullet)
  o.type = type
  GameData.sounds.weapon.pistol:stop()
  GameData.sounds.weapon.pistol:play()
  return o
end

function Bullet.make_all_fly(delta_frame)
  for key, bullet in ipairs(GameData.bullets) do
    local change_x = bullet.x + (bullet.x_acceleration * bullet.speed * delta_frame)
    local change_y = bullet.y + (bullet.y_acceleration * bullet.speed * delta_frame)
    bullet.x = change_x
    bullet.y = change_y

    if bullet.x > GameData.settings.world_w or bullet.y > GameData.settings.world_h or bullet.x < 0 or bullet.y < 0 then
      table.remove(GameData.bullets,
                   key)
    end

    for zkey, z in ipairs(GameData.zombies) do
      if Utils.CheckCollision(z.x,
                              z.y,
                              z.w,
                              z.h,
                              bullet.x,
                              bullet.y,
                              4,
                              4) then
        GameData.sounds.zombie.impact:stop()
        GameData.sounds.zombie.impact:play()
        z.health = z.health - 50
        --- hit blood
        for i = 0, math.random(0, 2) do
          local x = math.random(z.x - 20, z.x + z.w + 20)
          local y = math.random(z.y - 20, z.y + z.h + 20)
          NonInteractionObject.new(
            x, y, GameData.textures.zombie_textures.zombie_blood,
            math.random(0, 62),
            math.random(2, 10),
            nil
          )
        end

        if z.health <= 0 then
          z:die()

          table.remove(
            GameData.zombies,
            zkey
          )
          NonInteractionObject.new(
            z.x,
            z.y,
            z.die_texture,
            z.rotation,
            15,
            false,
            z.w,
            z.h
          )
          GameData.player.kills = GameData.player.kills + 1

          if bullet.type == "rifle" then
            for i = 0, math.random(0, 3) do
              local x = math.random(bullet.x - 60, bullet.x + 70)
              local y = math.random(bullet.y - 60, bullet.y + 70)
              NonInteractionObject.new(
                x, y, GameData.textures.zombie_textures.zombie_blood,
                math.random(0, 62),
                math.random(2, 10),
                nil
              )
            end
            GameData.sounds.zombie.impact:stop()
            GameData.sounds.zombie.impact:play()
          elseif bullet.type == "granate" then
            for i = 0, math.random(0, 7) do
              local x = math.random(bullet.x - 120, bullet.x + 200)
              local y = math.random(bullet.y - 120, bullet.y + 200)
              NonInteractionObject.new(
                x, y, GameData.textures.zombie_textures.zombie_blood,
                math.random(0, 62),
                math.random(2, 15),
                nil
              )
            end
            GameData.sounds.weapon.explosion:stop()
            GameData.sounds.weapon.explosion:play()
          end
        end
        -- increase the shooting speed
        -- GameData.player.weapon.shoot_delay = GameData.player.weapon.shoot_delay - 0.0002

        -- kill more enemies if the bullet si a granate
        if bullet.type == "granate" then
          GameData.sounds.weapon.explosion:stop()
          GameData.sounds.weapon.explosion:play()
          for z2key, z2 in ipairs(GameData.zombies) do
            if Utils.CheckCollision(z2.x,
                                    z2.y,
                                    z.w,
                                    z.h,
                                    bullet.x - 150,
                                    bullet.y - 150,
                                    300,
                                    300
            ) then
              -- kill all people around
              --[[NonInteractionObject.new(
                z2.x,
                z2.y,
                GameData.textures.zombie_textures.dead,
                z2.rotation
              )]]--

              --- the mobs in the heart of the explosion get more damage
              if Utils.CheckCollision(z2.x,
                                      z2.y,
                                      z2.w,
                                      z2.h,
                                      bullet.x - 70,
                                      bullet.y - 70,
                                      140,
                                      140
              ) then
                z2.health = z2.health - 140  -- extra 100 damage for the heart of the explosion

              end

              z2.health = z2.health - 50
              --- hit blood
              for i = 0, math.random(0, 2) do
                local x = math.random(bullet.x - 60, bullet.x + 70)
                local y = math.random(bullet.y - 60, bullet.y + 70)
                NonInteractionObject.new(
                  x, y, GameData.textures.zombie_textures.zombie_blood,
                  math.random(0, 62),
                  math.random(2, 10),
                  nil
                )
              end
              if z2.health <= 0 then

                table.remove(
                  GameData.zombies,
                  z2key
                )
                z2:die()

                -- hand graned blod no zombie korpse but more blood
                for i = 0, math.random(0, 7) do
                  local x = math.random(bullet.x - 120, bullet.x + 200)
                  local y = math.random(bullet.y - 120, bullet.y + 200)
                  NonInteractionObject.new(
                    x, y, GameData.textures.zombie_textures.zombie_blood,
                    math.random(0, 62),
                    math.random(2, 15),
                    nil
                  )
                end

                GameData.player.kills = GameData.player.kills + 1
              end
            end
          end

          --- fire
          for i = 0, 30 do
            local x = math.random(bullet.x - 100, bullet.x + 100)
            local y = math.random(bullet.y - 100, bullet.y + 100)
            NonInteractionObject.new(
              x, y, GameData.textures.projectile_textures.fire,
              math.random(0, 62),
              0.3,
              true
            )
          end
          --- smoke
          for i = 0, 100 do
            local x = math.random(bullet.x - 130, bullet.x + 130)
            local y = math.random(bullet.y - 130, bullet.y + 130)
            NonInteractionObject.new(
              x, y, GameData.textures.projectile_textures.smoke,
              math.random(0, 62), math.random(2, 5),
              true
            )
          end
          -- mess smoke at the out side but not none
          for i = 0, 70 do
            local x = math.random(bullet.x - 180, bullet.x + 180)
            local y = math.random(bullet.y - 180, bullet.y + 180)
            if (x < bullet.x - 130 or x > bullet.x + 130) and
              (y < bullet.y - 130 or y > bullet.y + 130) then
              NonInteractionObject.new(
                x, y, GameData.textures.projectile_textures.smoke,
                math.random(0, 62), math.random(2, 5),
                true
              )
            end
          end

        end

        if not bullet.hard then
          table.remove(GameData.bullets,
                       key)
        end

      end
    end
  end
end

function Bullet.draw_all()
  for key, bullet in ipairs(GameData.bullets) do
    DrawProtocol(bullet)
  end
end

return Bullet