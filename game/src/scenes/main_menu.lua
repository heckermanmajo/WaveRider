local MainMenu = {}

function MainMenu.init()

end

function MainMenu.update(delta_frame)

  local mx = love.mouse.getX()
  local my = love.mouse.getY()

  if love.mouse.isDown(1) then
    if Utils.CheckCollision(mx,my, 3,3,200,200,100,32) then
      print("Start Game")
      WaveGame.init()
      GameData.game_view_mode = "battle"
    end

    if Utils.CheckCollision(mx,my, 3,3,200,400,100,32) then
      print("Load campaign")
      WaveGame.init()
      GameData.game_view_mode = "battle"
    end

    if Utils.CheckCollision(mx,my, 3,3,200,600,100,32) then
      love.event.quit()
    end
  end
  Player.number_cool_down = Player.number_cool_down- delta_frame

end

function MainMenu.display(delta_frame)

  love.graphics.clear({0,0,1,1})

  love.graphics.draw(GameData.textures.zombie_textures.big_zombie, 200, 200, 0, 1, 1, 0, 0, 0, 0)

  --love.graphics.draw(GameData.textures.menu.map, 200,200,0,4,4)

  --love.graphics.draw(GameData.textures.menu.ork, 1200,600,0,4,4)

  love.graphics.setColor(1,1,1,1)
  love.graphics.print("Main menu ", 50,50,0,2,2)

  love.graphics.draw(
    GameData.textures.menu.start,  -- 100 x 32
    200,
    200
  )

  love.graphics.draw(
    GameData.textures.menu.load,  -- 100 x 32
    200,
    300
  )

  love.graphics.draw(
    GameData.textures.menu.continue,  -- 100 x 32
    200,
    400
  )

  love.graphics.draw(
    GameData.textures.menu.controls,  -- 100 x 32
    200,
    500
  )

  love.graphics.draw(
    GameData.textures.menu.exit,  -- 100 x 32
    200,
    600
  )

end

--- Clear up the main menu, before switching to another game view
function MainMenu.prepare_ending()

end

function MainMenu.reset()

end

return MainMenu