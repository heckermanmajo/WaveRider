local MobController = {}

function MobController.init()
  local m = Mob:new(400, 400)
  Mob.update_move_target(m, Tile.get(800, 800))
end

function MobController.update(delta_frame)
  for i = 1, #Mob.instances do
    --- @type Mob
    local m = Mob.instances[i]
    if m ~= nil then
      Mob.move(m, delta_frame)
    end
  end

  if love.mouse.isDown(1) and Player.number_cool_down <= 0 then
    --- @type Mob
    local m = Mob.instances[1]
    Mob.update_move_target(m,Tile.get(
      love.mouse.getX() + GameData.settings.screen_x_view_factor,
      love.mouse.getY() + GameData.settings.screen_y_view_factor
    ))
    Player.number_cool_down = 0.2
  end
end

function MobController.draw()

  for i = 0, #Mob.instances - 1 do
    --- @type Mob
    local m = Mob.instances[i + 1]
    Mob.draw_mob(m)
  end

end

return MobController