
--- Wavegame core class
local WaveGame={
  queue={},
  queuetime=0,
  updatequeue=function(dt)
    WaveGame.queuetime=WaveGame.queuetime + dt
    for i=#WaveGame.queue,1,-1 do
      if WaveGame.queue[i] and (WaveGame.queue[i].time < WaveGame.queuetime) then
        WaveGame.queue[i].func()
        table.remove(WaveGame.queue,i)
      end
    end
  end,
  delay=function(func,time)
    --execute the function "func" after time "time"
    table.insert(WaveGame.queue,{time=WaveGame.queuetime + time,func=func})
  end
}


--- Init the wave game
function WaveGame.init()
  Player.x = GameData.settings.screen_w/2 - Player.w /2
  Player.y = GameData.settings.screen_h/2 - Player.w /2

  -- this spawns a zombie all 5 seconds
  WaveGame.delay(Zombie.spawn,5)
  WaveGame.delay(FirstAid.spawn,5)
  -- this spawns ammo indefinitely
  Ammo.spawn_ammo_interval()
  Ammo.spawn_granate_interval()
  -- all 10 seconds a wave
  GameData.zombie_config.wave_timer=10
  -- creates the waves
  Zombie.make_wave()
  Money.spawn()
  Tile.create_all_tiles()
  Tile.init()
  InventoryController.init()
  Building.init()
  PlayerPlaceBuildingsController.init()
  MobController.init()
end


--- Update: Call each frame
--- @param delta_frame number
function WaveGame.update(delta_frame)
  local game_state = GameData
  InventoryController.update()

  -- basic updates
  love.graphics.setBackgroundColor(10 / 255,
    191 / 255,
    88 / 255,
    1
  )

  if love.keyboard.isDown("p") and GameData.player.number_cool_down <= 0 then
    GameData.pause = not GameData.pause
    GameData.player.number_cool_down = 0.2
  end

  if GameData.pause then
    GameData.player.number_cool_down = GameData.player.number_cool_down - delta_frame
    return
  end

  WaveGame.updatequeue(delta_frame)

  -- game data updates
  GameData.zombie_config.wave_timer=GameData.zombie_config.wave_timer - delta_frame

  -- player updates
  Player.movement_controller(delta_frame)
  Player.shoot(delta_frame)
  Player.die(delta_frame)

  -- menu-stuff
  if love.keyboard.isDown('escape') then
    love.event.quit()
  end

  -- physics
  Bullet.make_all_fly(delta_frame)

  -- ai
  Zombie.move_and_fight(delta_frame)

  -- interaction
  FirstAid.pickup(delta_frame)
  Ammo.pickup()

  -- remove these over time if they should be removed
  NonInteractionObject.progress(delta_frame)

  NonInteractionObjectController.update(game_state, delta_frame)
  Money.upadte(delta_frame)
  Trooper.update_all(delta_frame)

  PlayerAirStrikeController.strike()
  MinimapController.update(delta_frame)
  Tile.update(delta_frame)
  Building.update(delta_frame)
  PlayerPlaceBuildingsController.update(delta_frame)
  --MobController.update(delta_frame)
end

function WaveGame.display(delta_frame)
  --love.graphics.setCanvas(GameData.interna.buffer_canvas)
  --love.graphics.clear()
  Tile.draw(Tile.all)
  Building.draw()
  NonInteractionObject.draw_all()
  Bullet.draw_all()
  Ammo.draw_all()
  FirstAid.draw_all()
  Zombie.draw_all()
  Player.draw_player_and_hud()
  Money.draw()
  Trooper.draw_all()
  MinimapController.draw()
  InventoryController.draw()
  PlayerPlaceBuildingsController.draw()
  --MobController.draw()

  -- Draw a rect around the movable space

  love.graphics.setColor(1,1,1,1)
  love.graphics.rectangle(
    "line",
    3 - GameData.settings.screen_x_view_factor,
    3- GameData.settings.screen_y_view_factor,
    GameData.settings.world_w-3,
    GameData.settings.world_h-3
  )
  love.graphics.setColor(1,1,1,1)

  DebugController.display_debug_information()
  --love.graphics.setCanvas()
  --love.graphics.draw(GameData.interna.buffer_canvas,0,0)
end

--- Clear up the main menu, before switching to another game view
function WaveGame.prepare_ending()

end

--- Reset all state of the current game
function WaveGame.reset()

end

return WaveGame