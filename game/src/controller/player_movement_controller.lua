function MovementController(delta_frame)
  -- Draw a rect around the movable space



  --- the moevement can beimpoorved by checking before setting and not setting back
  --[[
  if Player.x + 200 > GameData.settings.screen_w + GameData.settings.screen_x_view_factor then
    if GameData.settings.screen_x_view_factor < GameData.settings.world_w - GameData.settings.screen_w then
      GameData.settings.screen_x_view_factor = GameData.settings.screen_x_view_factor + Player.speed * delta_frame
    else
      GameData.settings.screen_x_view_factor = GameData.settings.world_w - GameData.settings.screen_w
    end
  end

  if Player.x - 200 < GameData.settings.screen_x_view_factor then
    if GameData.settings.screen_x_view_factor > 0 then
      GameData.settings.screen_x_view_factor = GameData.settings.screen_x_view_factor - Player.speed * delta_frame
    else
      GameData.settings.screen_x_view_factor = 0
    end
  end

  if Player.y + 200 > GameData.settings.screen_h + GameData.settings.screen_y_view_factor then
    if GameData.settings.screen_y_view_factor < GameData.settings.world_h - GameData.settings.screen_h then
      GameData.settings.screen_y_view_factor = GameData.settings.screen_y_view_factor + Player.speed * delta_frame
    else
      GameData.settings.screen_y_view_factor = GameData.settings.world_h - GameData.settings.screen_h
    end

  end

  if Player.y - 200 < GameData.settings.screen_y_view_factor then
    if GameData.settings.screen_y_view_factor > 0 then
      GameData.settings.screen_y_view_factor = GameData.settings.screen_y_view_factor - Player.speed * delta_frame
    else
      GameData.settings.screen_y_view_factor = 0
    end
  end

  if Player.x < 0 then
    Player.x = 0
    GameData.settings.screen_x_view_factor = 0
  end

  if Player.y < 0 then
    Player.y = 0
    GameData.settings.screen_y_view_factor = 0
  end

  if Player.x + Player.w > GameData.settings.world_w then
    Player.x = GameData.settings.world_w - Player.w
    GameData.settings.screen_x_view_factor = GameData.settings.world_w - GameData.settings.screen_w
  end

  if Player.x + Player.h > GameData.settings.world_h then
    Player.x = GameData.settings.world_h - Player.h
    GameData.settings.screen_y_view_factor = GameData.settings.world_h - GameData.settings.screen_h
  end
  ]]

  -- player movement

  --- dont change the walk direction
  --[[if love.keyboard.isDown('d') and not love.keyboard.isDown('w') then
    local mx = love.mouse.getY() + GameData.settings.screen_x_view_factor
    local my = love.mouse.getX() + GameData.settings.screen_y_view_factor
    Player.player_walk_direction = (math.atan2(
      (my - Player.x),
      -(mx - Player.y)
    ))
    GameData.player.x = GameData.player.x + math.cos(Player.player_walk_direction) * GameData.player.speed * delta_frame
    GameData.player.y = GameData.player.y + math.sin(Player.player_walk_direction) * GameData.player.speed * delta_frame
    GameData.settings.screen_x_view_factor = GameData.settings.screen_x_view_factor+ math.cos(Player.player_walk_direction) * GameData.player.speed * delta_frame
    GameData.settings.screen_y_view_factor = GameData.settings.screen_y_view_factor+ math.sin(Player.player_walk_direction) * GameData.player.speed * delta_frame
    if GameData.settings.screen_x_view_factor > GameData.settings.world_w - GameData.settings.screen_w then
      GameData.settings.screen_x_view_factor = GameData.settings.world_w - GameData.settings.screen_w
    end
    if GameData.settings.screen_x_view_factor < 0 then
      GameData.settings.screen_x_view_factor = 0
    end
  end

  if love.keyboard.isDown('a') and not love.keyboard.isDown('w') then
    local mx = love.mouse.getX() + GameData.settings.screen_x_view_factor
    local my = love.mouse.getY() + GameData.settings.screen_y_view_factor
    Player.player_walk_direction = (math.atan2(
      (my - Player.x),
      -(mx - Player.y)
    ))
    GameData.player.x = GameData.player.x - math.cos(Player.player_walk_direction) * GameData.player.speed * delta_frame
    GameData.player.y = GameData.player.y - math.sin(Player.player_walk_direction) * GameData.player.speed * delta_frame
  end--]]

  if love.keyboard.isDown('w') then
    Player.player_walk_direction = (math.atan2((love.mouse.getY() + GameData.settings.screen_y_view_factor - GameData.player.y),
                                               (love.mouse.getX() + GameData.settings.screen_x_view_factor - GameData.player.x)))

    local x_change = math.cos(Player.player_walk_direction) * GameData.player.speed * delta_frame
    local y_change = math.sin(Player.player_walk_direction) * GameData.player.speed * delta_frame

    if Player.x < 0 then
      Player.x = 0
      GameData.settings.screen_x_view_factor = -int(GameData.settings.screen_w / 2)
    elseif  Player.x > GameData.settings.world_w-Player.w  then
      Player.x = int(GameData.settings.world_w-Player.w)
      GameData.settings.screen_x_view_factor = int(GameData.settings.world_w - GameData.settings.screen_w / 2)
    else
      GameData.player.x = int(GameData.player.x + x_change)
      GameData.settings.screen_x_view_factor = int(GameData.settings.screen_x_view_factor+ x_change)
    end
    if Player.y < 0  then
      Player.y = 0
      GameData.settings.screen_y_view_factor = -int(GameData.settings.screen_h / 2)
    elseif  Player.y > GameData.settings.world_h then
      Player.y = int(GameData.settings.world_h)
      GameData.settings.screen_y_view_factor = int(GameData.settings.world_h -GameData.settings.screen_h / 2)
    else
      GameData.player.y = int(GameData.player.y + y_change)
      GameData.settings.screen_y_view_factor = int(GameData.settings.screen_y_view_factor + y_change)
    end


  end

  if love.keyboard.isDown('s') and not love.keyboard.isDown('w') then

    Player.player_walk_direction = (math.atan2((love.mouse.getY() + GameData.settings.screen_y_view_factor - GameData.player.y),
                                               (love.mouse.getX() + GameData.settings.screen_x_view_factor - GameData.player.x)))
    local x_change =  - math.cos(Player.player_walk_direction) * GameData.player.speed * delta_frame
    local y_change =  - math.sin(Player.player_walk_direction) * GameData.player.speed * delta_frame
    if Player.x < 0 then
      Player.x = 0
      GameData.settings.screen_x_view_factor = -int(GameData.settings.screen_w / 2)
    elseif  Player.x > GameData.settings.world_w-Player.w  then
      Player.x = int(GameData.settings.world_w-Player.w)
      GameData.settings.screen_x_view_factor = int(GameData.settings.world_w - GameData.settings.screen_w / 2)
    else
      GameData.player.x = int(GameData.player.x + x_change)
      GameData.settings.screen_x_view_factor = int(GameData.settings.screen_x_view_factor+ x_change)
    end
    if Player.y < 0  then
      Player.y = 0
      GameData.settings.screen_y_view_factor = -GameData.settings.screen_h / 2
    elseif  Player.y > GameData.settings.world_h then
      Player.y = int(GameData.settings.world_h)
      GameData.settings.screen_y_view_factor = int(GameData.settings.world_h -GameData.settings.screen_h / 2)
    else
      GameData.player.y = int(GameData.player.y + y_change)
      GameData.settings.screen_y_view_factor = int(GameData.settings.screen_y_view_factor+ y_change)
    end

  end




end

function move_screen_factor(x_change, y_change)
  if Player.x > GameData.settings.screen_w/ 2 - Player.w  and Player.x < GameData.settings.world_w - GameData.settings.screen_w/2 then
    GameData.settings.screen_x_view_factor = GameData.settings.screen_x_view_factor+ x_change
  end
  if Player.y > GameData.settings.screen_h/ 2 - Player.h  and Player.h < GameData.settings.world_h - GameData.settings.screen_h/2 then
    GameData.settings.screen_y_view_factor = GameData.settings.screen_y_view_factor+ y_change
  end

  if GameData.settings.screen_x_view_factor > GameData.settings.world_w - GameData.settings.screen_w then
    GameData.settings.screen_x_view_factor = GameData.settings.world_w - GameData.settings.screen_w
  end
  if GameData.settings.screen_x_view_factor < 0 then
    GameData.settings.screen_x_view_factor = 0
  end
  if GameData.settings.screen_y_view_factor > GameData.settings.world_h - GameData.settings.screen_h then
    GameData.settings.screen_y_view_factor = GameData.settings.world_h - GameData.settings.screen_h
  end
  if GameData.settings.screen_y_view_factor < 0 then
    GameData.settings.screen_y_view_factor = 0
  end
end

return MovementController