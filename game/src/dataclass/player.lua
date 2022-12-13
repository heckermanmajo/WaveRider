



ShootDelay = 0  -- todo: move into player struct



local Player = {
  player_walk_direction = 0,
  granate_cool_down = 0,
  number_cool_down = 0,
  minimap = false,
  kills = 0,
  money = 25,
  x = nil,
  y = nil,
  w = 32,
  h = 32,
  collision_force_x = 0,
  collision_force_y = 0,
  hard = false,
  direction = 0,
  weapon = {
    automatic = true, -- false for click for shoot
    shoot_delay = 0.2, -- only 4 bullets per second
    bullets = 20,
    granates = 0,
    aim_loss = 0.05,
    weapon_mode = "rifle",
    gas = 0,
    shotgun_ammo = 0,
  },
  speed = 200,
  health = 50,
  hud_mode = "fight", --- trade or fight
  selcted_unit = nil,
  -- can be used later to control multiple units as "Player"
  currently_controlled = Player
}




-- put it into the player controller
function Player.movement_controller(delta_frame)

  local change_x = Player.collision_force_x * delta_frame
  local change_y = Player.collision_force_y * delta_frame
  Player.x = Player.x + change_x
  Player.y = Player.y + change_y
  Player.collision_force_x = Player.collision_force_x - change_x
  Player.collision_force_y = Player.collision_force_y - change_y

  if love.keyboard.isDown("f3") and Player.number_cool_down <= 0 then
    for i = 0, 50 do
      local z = Zombie.new(0, math.random(0, GameData.settings.world_h), math.random(10, 30))
      z.state = "hunting"
      table.insert(GameData.zombies, z)
      ---table.insert(zombies_of_wave, z)
      z.wander_off = true
    end
    Player.number_cool_down = 0.2
  end

  PlayerMovementController(delta_frame)

  Player.number_cool_down = Player.number_cool_down - delta_frame

  if love.keyboard.isDown("f1") and Player.number_cool_down <= 0 then
    if GameData.game_mode == "wave" then
      GameData.game_mode = "surrival"
      GameData.zombie_config.wave_space_between_time = 35
    else
      GameData.game_mode = "wave"
      GameData.zombie_config.wave_space_between_time = 5
    end
    Player.number_cool_down = 0.2
  end


  -- todo trade mode into the rts controller
  if Player.hud_mode == "trade" then

    if love.mouse.isDown(1) then
      for key, t in ipairs(GameData.trooper) do
        if Utils.CheckCollision(
          love.mouse.getX() + GameData.settings.screen_x_view_factor,
          love.mouse.getY() + GameData.settings.screen_y_view_factor,
          5, 5,
          t.x,
          t.y, 32, 32
        ) then
          Player.selected_unit = t
          for i, _t in ipairs(GameData.trooper) do
            _t.selected = false
          end
          t.selected = true
        end
      end
      Player.number_cool_down = 0.1
    end

    if love.mouse.isDown(2) then
      if Player.selected_unit ~= nil then
        Player.selected_unit.move_target_x = love.mouse.getX() + GameData.settings.screen_x_view_factor
        Player.selected_unit.move_target_y = love.mouse.getY() + GameData.settings.screen_y_view_factor
      end
    end

  end

  if love.keyboard.isDown('b') and Player.number_cool_down <= 0 then
    Player.number_cool_down = 0.2
    if Player.hud_mode == "trade" then
      love.mouse.setCursor(GameData.cursor.cursor_target, 16, 16)
      Player.hud_mode = "fight"
    else
      love.mouse.setCursor(GameData.cursor.cursor_arrow, 0, 0)
      Player.hud_mode = "trade"
    end
  end

  if love.keyboard.isDown("tab") and Player.number_cool_down <= 0 then
    Player.number_cool_down = 0.2
    if Player.hud_mode == "trade" then
      love.mouse.setCursor(GameData.cursor.cursor_target, 16, 16)
      Player.hud_mode = "fight"
    else
      love.mouse.setCursor(GameData.cursor.cursor_arrow, 0, 0)
      Player.hud_mode = "trade"
    end
  end

  if Player.hud_mode == "trade" then

    --- spawn trooper around the player
    ---
    if love.keyboard.isDown("1") and Player.number_cool_down <= 0 then
      --- buy soldier
      ------ todo: maybe do not spawn near zombie
      if (Player.money >= 25) then

        Player.money = Player.money - 25
        Trooper:new(
          math.random(math.floor(Player.x - 500), math.floor(Player.x + 500)),
          math.random(math.floor(Player.y - 500), math.floor(Player.y + 500)),
          "trooper"
        )
        Player.number_cool_down = 0.2
      end
    end

    if love.keyboard.isDown("2") and Player.number_cool_down <= 0 then
      --- buy granates
      if (Player.money >= 50) then
        Player.money = Player.money - 50
        Trooper:new(
          math.random(math.floor(Player.x - 500), math.floor(Player.x + 500)),
          math.random(math.floor(Player.y - 500), math.floor(Player.y + 500)),
          "shotgun_trooper"
        )
        Player.number_cool_down = 0.2
      end
    end

    if love.keyboard.isDown("3") and Player.number_cool_down <= 0 then
      --- buy mg
      if (Player.money >= 100) then
        Player.money = Player.money - 100
        Trooper:new(
          math.random(math.floor(Player.x - 500), math.floor(Player.x + 500)),
          math.random(math.floor(Player.y - 500), math.floor(Player.y + 500)),
          "rpg_trooper"
        )
        Player.number_cool_down = 0.2
      end
    end

    if love.keyboard.isDown("4") and Player.number_cool_down <= 0 then

    end

    if love.keyboard.isDown("left") and Player.number_cool_down <= 0 then
      for i, t in ipairs(GameData.trooper) do
        t.move_target_x = t.x - math.random(70, 100)
      end
      Player.number_cool_down = 0.5
    end

    if love.keyboard.isDown("right") and Player.number_cool_down <= 0 then
      for i, t in ipairs(GameData.trooper) do
        t.move_target_x = t.x + math.random(70, 100)
      end
      Player.number_cool_down = 0.5
    end

    if love.keyboard.isDown("up") and Player.number_cool_down <= 0 then
      for i, t in ipairs(GameData.trooper) do
        t.move_target_y = t.y - math.random(70, 100)
      end
      Player.number_cool_down = 0.5
    end

    if love.keyboard.isDown("down") and Player.number_cool_down <= 0 then
      for i, t in ipairs(GameData.trooper) do
        t.move_target_y = t.y + math.random(70, 100)
      end
      Player.number_cool_down = 0.5
    end

  end

  if Player.hud_mode == "fight" then

    if love.keyboard.isDown("1") and Player.number_cool_down <= 0 then
      Player.weapon.weapon_mode = "rifle"
      Player.number_cool_down = 1
      GameData.sounds.weapon.reload_pistol:stop()
      GameData.sounds.weapon.reload_pistol:play()
    end

    if love.keyboard.isDown("2") and Player.number_cool_down <= 0 then
      Player.weapon.weapon_mode = "shotgun"
      Player.number_cool_down = 1
      GameData.sounds.weapon.reload_shotgun:stop()
      GameData.sounds.weapon.reload_shotgun:play()
    end

    if love.keyboard.isDown("3") and Player.number_cool_down <= 0 then
      Player.weapon.weapon_mode = "rpg"
      Player.number_cool_down = 1
      GameData.sounds.weapon.reload_shotgun:stop()
      GameData.sounds.weapon.reload_shotgun:play()
    end

  end

  GameData.player.direction = Utils.get_rotation(
    GameData.player.x,
    GameData.player.y,
    love.mouse.getX() + GameData.settings.screen_x_view_factor,
    love.mouse.getY() + GameData.settings.screen_y_view_factor
  )

end




--- shooting split up into the weapon controllers
function Player.shoot(delta_frame)

  if Player.hud_mode == "fight" then
    Player.granate_cool_down = Player.granate_cool_down - delta_frame

    if love.mouse.isDown(1) then
      if Player.weapon.weapon_mode == "shotgun" then
        if GameData.player.weapon.shotgun_ammo >= 1 then
          if ShootDelay <= 0 then

            local d = Utils.distance(
              GameData.player.x,
              GameData.player.y,
              love.mouse.getX() + GameData.settings.screen_x_view_factor,
              love.mouse.getY() + GameData.settings.screen_y_view_factor
            )
            d = d * 0.300

            for i = 0, 10 do
              table.insert(
                GameData.bullets,
                Bullet.new(
                  GameData.player.x, --start_x,
                  GameData.player.y, --start_y,
                  love.mouse.getX()
                    + GameData.settings.screen_x_view_factor
                    + math.random(-d, d), --target_x,
                  love.mouse.getY()
                    + GameData.settings.screen_y_view_factor
                    + math.random(-d, d), --target_y,
                  GameData.player.direction, --direction,
                  500, --speed
                  "rifle"
                )
              )
            end

            GameData.player.weapon.shotgun_ammo = GameData.player.weapon.shotgun_ammo - 1
            ShootDelay = 0.8
            GameData.sounds.weapon.reload_shotgun:stop()
            GameData.sounds.weapon.reload_shotgun:play()
          end
        else
          GameData.sounds.weapon.empty:stop()
          GameData.sounds.weapon.empty:play()
        end
      end
      if Player.weapon.weapon_mode == "rifle" then
        if GameData.player.weapon.bullets > 0 then
          if ShootDelay <= 0 then

            if GameData.player.weapon.shoot_delay < 0.2 then
              GameData.player.weapon.shoot_delay = 0.2
            end

            ShootDelay = GameData.player.weapon.shoot_delay

            local d = Utils.distance(
              GameData.player.x,
              GameData.player.y,
              love.mouse.getX() + GameData.settings.screen_x_view_factor,
              love.mouse.getY() + GameData.settings.screen_y_view_factor
            )
            d = d * GameData.player.weapon.aim_loss

            table.insert(
              GameData.bullets,
              Bullet.new(
                GameData.player.x, --start_x,
                GameData.player.y, --start_y,
                love.mouse.getX()
                  + GameData.settings.screen_x_view_factor
                  + math.random(-d, d), --target_x,
                love.mouse.getY()
                  + GameData.settings.screen_y_view_factor
                  + math.random(-d, d), --target_y,
                GameData.player.direction, --direction,
                500, --speed
                "rifle"
              )
            )
            GameData.player.weapon.bullets = GameData.player.weapon.bullets - 1
          end
        else
          GameData.sounds.weapon.empty:stop()
          GameData.sounds.weapon.empty:play()
        end
      end

      if Player.weapon.weapon_mode == "rpg" then
        if GameData.player.weapon.granates > 0 then
          if Player.granate_cool_down <= 0 then
            table.insert(
              GameData.bullets,
              Bullet.new(
                GameData.player.x, --start_x,
                GameData.player.y, --start_y,
                love.mouse.getX() + GameData.settings.screen_x_view_factor, --target_x,
                love.mouse.getY() + GameData.settings.screen_y_view_factor, --target_y,
                GameData.player.direction, --direction,
                500, --speed,
                "granate"
              )
            )
            Player.granate_cool_down = 1
            GameData.player.weapon.granates = GameData.player.weapon.granates - 1
          end
        else

          GameData.sounds.weapon.empty:stop()
          GameData.sounds.weapon.empty:play()

        end
      end
    end

  end
  if ShootDelay > 0 then
    ShootDelay = ShootDelay - delta_frame
  end

end



function Player.die(delta_frame)
  if GameData.player.health < 0 then
    GameData.current_game_view = "main_menu"
  end
end



-- todo: hud into the hud_controller
function Player.draw_player_and_hud()

  Player.texture = GameData.textures.player_textures.rifle
  if Player.hud_mode == "trade" then
    Player.texture = GameData.textures.player_textures.computer
  else
    if Player.weapon.weapon_mode == "shotgun" then
      Player.texture = GameData.textures.player_textures.shotgun
    end
    if Player.weapon.weapon_mode == "rpg" then
      Player.texture = GameData.textures.player_textures.rgp
    end
  end

  -- fixme: only use rotation and delete direction
  Player.rotation = Player.direction
  DrawProtocol(Player)

  local color = { 0, 200, 0 }
  if GameData.player.health < 100 then
    color = { 255, 0, 0 }
  elseif GameData.player.health < 300 then
    color = { 255, 100, 100 }
  end

  love.graphics.print(
    { { 255, 255, 255 }, "Bullets: " .. tostring(math.floor(GameData.player.weapon.bullets)) },
    200, 20, 0, 2, 2
  )
  love.graphics.print(
    { { 255, 255, 255 }, "Granates: " .. tostring(math.floor(GameData.player.weapon.granates)) },
    200, 50, 0, 2, 2
  )

  love.graphics.print(
    { color, "Health: " .. tostring(math.floor(GameData.player.health)) },
    200, 80, 0, 2, 2
  )

  love.graphics.print(
    { color, "Buckshot: " .. tostring(math.floor(GameData.player.weapon.shotgun_ammo)) },
    200, 110, 0, 2, 2
  )

  love.graphics.print(
    { color, "Gas: " .. tostring(math.floor(GameData.player.weapon.gas)) },
    200, 140, 0, 2, 2
  )

  love.graphics.print(
    { { 255, 255, 255 }, "Wave : " .. tostring(GameData.zombie_config.wave_counter) },
    500, 80, 0, 2, 2
  )

  love.graphics.print(
    { { 255, 255, 255 }, "Kills : " .. tostring(GameData.player.kills) },
    500, 50, 0, 2, 2
  )
  if GameData.game_mode == "surrival" then
    love.graphics.print(
      { { 255, 255, 255 }, "Wave in : " .. tostring(math.floor(GameData.zombie_config.wave_timer)) },
      500, 20, 0, 2, 2
    )
  else
    love.graphics.print(
      { { 255, 255, 255 }, "Kill the wave" },
      500, 20, 0, 2, 2
    )
  end
  love.graphics.print(
    { { 255, 255, 255 }, "Weapon : " .. GameData.player.weapon.weapon_mode },
    760, 20, 0, 2, 2
  )
  love.graphics.print(
    { { 255, 255, 255 }, "Money : " .. math.floor(GameData.player.money) },
    760, 50, 0, 2, 2
  )

  love.graphics.print(
    { { 255, 255, 255 }, "Mode : " .. GameData.player.hud_mode },
    760, 80, 0, 2, 2
  )
end

return Player